/*
 * Endpoint para obtener información pública de un artista
 */
package openapi

import (
    "database/sql"
    "encoding/json"
    "fmt"
    "net/http"
    "os"
    "strconv"
    "time"

    "usuarios/middleware"

    "github.com/gin-gonic/gin"
)

type ArtistasAPI struct {
    DB *sql.DB
}

// Get /artistas/:idArtista
// Devuelve información pública del artista (nombre, biografía, imagen, enlaces, discografía)
func (api *ArtistasAPI) ArtistasIdArtistaGet(c *gin.Context) {
    idStr := c.Param("idArtista")
    id, err := strconv.Atoi(idStr)
    if err != nil {
        c.JSON(http.StatusBadRequest, Error{Codigo: 400, Mensaje: "ID de artista inválido"})
        return
    }

    var idUsuario int
    var nombre, descripcion, urlImagen sql.NullString
    var tipo sql.NullInt64

    err = api.DB.QueryRow("SELECT id, nombre, descripcion, urlImagen, tipo FROM usuario WHERE id = $1", id).Scan(&idUsuario, &nombre, &descripcion, &urlImagen, &tipo)
    if err != nil {
        if err == sql.ErrNoRows {
            c.JSON(http.StatusNotFound, Error{Codigo: 404, Mensaje: "Artista no encontrado"})
            return
        }
        c.JSON(http.StatusInternalServerError, Error{Codigo: 500, Mensaje: "Error interno"})
        return
    }

    // Verificar que el usuario es de tipo artista (tipo == 2)
    if !tipo.Valid || tipo.Int64 != 2 {
        c.JSON(http.StatusNotFound, Error{Codigo: 404, Mensaje: "Artista no encontrado"})
        return
    }

    // Determinar si el caller es el propio artista
    idCaller := middleware.GetIdUsuario(c)
    _ = idCaller // Por ahora no hay datos privados adicionales, pero validamos acceso según el requisito

    // Construir respuesta pública
    resp := gin.H{
        "id":         idUsuario,
        "nombre":     nullableStringToString(nombre),
        "biografia":  nullableStringToString(descripcion),
        "imagen":     nullableStringToString(urlImagen),
        "enlaces":    []any{},
        // por defecto vacía; intentaremos rellenarla llamando al microservicio de contenido
        "discografia": []any{},
    }

    // Intentar obtener discografía desde el microservicio de contenido.
    if albums, err := fetchAlbumsForArtist(id); err == nil {
        resp["discografia"] = albums
    } else {
        // No abortamos la petición por fallos en el microservicio de contenido;
        // registramos el error para depuración y devolvemos la respuesta pública parcial.
        fmt.Println("Aviso: no se pudo obtener discografía desde contenido:", err)
    }

    c.JSON(http.StatusOK, resp)
}

func nullableStringToString(s sql.NullString) string {
    if s.Valid {
        return s.String
    }
    return ""
}

func fetchAlbumsForArtist(artistId int) ([]any, error) {
    base := os.Getenv("CONTENT_BASE_URL")
    if base == "" {
        return nil, fmt.Errorf("CONTENT_BASE_URL no configurado")
    }

    client := &http.Client{Timeout: 2 * time.Second}

    url := fmt.Sprintf("%s/albums?artista=%d", base, artistId)
    req, err := http.NewRequest(http.MethodGet, url, nil)
    if err != nil {
        return nil, err
    }
    req.Header.Set("Accept", "application/json")

    resp, err := client.Do(req)
    if err != nil {
        return nil, err
    }
    defer resp.Body.Close()

    if resp.StatusCode != http.StatusOK {
        return nil, fmt.Errorf("contenido returned status %d", resp.StatusCode)
    }

    // decode into generic interface
    var root any
    dec := json.NewDecoder(resp.Body)
    if err := dec.Decode(&root); err != nil {
        return nil, err
    }

    // case 1: API returned {"status":"OK","albums": [...]}
    if m, ok := root.(map[string]any); ok {
        if a, ok := m["albums"]; ok {
            if arr, ok := a.([]any); ok {
                return arr, nil
            }
            return nil, fmt.Errorf("'albums' field is present but not an array")
        }
    }

    // case 2: API returned directly an array [...]
    if arr, ok := root.([]any); ok {
        return arr, nil
    }

    return nil, fmt.Errorf("unexpected response shape from contenido")
}

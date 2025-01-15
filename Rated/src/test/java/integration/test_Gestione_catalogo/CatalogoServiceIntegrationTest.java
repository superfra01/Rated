package integration.test_Gestione_catalogo;


import static org.junit.jupiter.api.Assertions.*;

import org.apache.commons.dbcp2.BasicDataSource;
import org.junit.jupiter.api.*;

import sottosistemi.Gestione_Catalogo.service.CatalogoService;
import model.DAO.FilmDAO;
import model.Entity.FilmBean;


import javax.sql.DataSource;

import java.sql.SQLException;
import java.util.List;

public class CatalogoServiceIntegrationTest {

    private static DataSource testDataSource; // DataSource condiviso per tutti i test

    private FilmDAO filmDAO;
    private CatalogoService catalogoService;

   

    @BeforeEach
    void setUp() {
        
        filmDAO = new FilmDAO(testDataSource);
        catalogoService = new CatalogoService(filmDAO);

        
    }

  
    @Test
    void testGetFilms_ReturnsAllFilms() {
        List<FilmBean> films = catalogoService.getFilms();
        assertNotNull(films, "La lista dei film non dovrebbe essere null.");
        // Se il DB è vuoto, la size potrebbe essere 0. Puoi fare assertTrue(films.isEmpty()) se sai di averlo pulito
    }

    @Test
    void testAggiungiFilm_ValidData_ShouldSaveToDatabase() {
        String nome = "Test Film";
        int anno = 2022;
        int durata = 120;
        String generi = "Azione";
        String regista = "John Doe";
        String attori = "Attore1, Attore2";
        byte[] locandina = null; 
        String trama = "Trama di test.";

        catalogoService.aggiungiFilm(nome, anno, durata, generi, regista, attori, locandina, trama);

        // Verifichiamo su DB
        List<FilmBean> allFilms = filmDAO.findAll();
        boolean found = allFilms.stream()
                .anyMatch(f -> f.getNome().equals(nome) && f.getAnno() == anno);
        assertTrue(found, "Il film appena aggiunto deve essere presente nel catalogo.");
    }

    @Test
    void testRicercaFilm_ExistingTitle_ShouldReturnResult() {
        // Inseriamo un film di test
        FilmBean film = new FilmBean();
        film.setNome("Inception");
        film.setAnno(2010);
        filmDAO.save(film);

        // Ora cerchiamo
        List<FilmBean> risultati = catalogoService.ricercaFilm("Inception");
        assertFalse(risultati.isEmpty(), "Dovrebbe trovare almeno un film con titolo 'Inception'.");
        assertEquals("Inception", risultati.get(0).getNome());
    }

    @Test
    void testRimuoviFilm_ShouldDeleteFromDB() {
        // Prepariamo un film di test
    	String nome = "FilmToRemove";
        int anno = 2022;
        int durata = 120;
        String generi = "Azione";
        String regista = "John Doe";
        String attori = "Attore1, Attore2";
        byte[] locandina = "s".getBytes(); 
        String trama = "Trama di test.";
        

        catalogoService.aggiungiFilm(nome, anno, durata, generi, regista, attori, locandina, trama);

        // Recupero dal DB per ottenerne l'ID
        List<FilmBean> all = filmDAO.findAll();
        FilmBean toRemove = all.stream()
                .filter(f -> "FilmToRemove".equals(f.getNome()))
                .findFirst()
                .orElse(null);
        assertNotNull(toRemove);

        // Rimuoviamolo via CatalogoService
        catalogoService.rimuoviFilm(toRemove);

        // Verifica che non esista più
        FilmBean check = filmDAO.findById(toRemove.getIdFilm());
        assertNull(check, "Il film dovrebbe essere stato rimosso dal database.");
    }
}

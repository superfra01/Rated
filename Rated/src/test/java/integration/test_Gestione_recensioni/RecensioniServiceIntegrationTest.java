package integration.test_Gestione_recensioni;


import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.*;

import sottosistemi.Gestione_Recensioni.service.RecensioniService;
import model.DAO.RecensioneDAO;
import model.DAO.FilmDAO;
import model.DAO.ValutazioneDAO;
import model.Entity.RecensioneBean;
import model.Entity.FilmBean;

import org.apache.commons.dbcp2.BasicDataSource;
import javax.sql.DataSource;

import java.util.List;

public class RecensioniServiceIntegrationTest {

    private static DataSource testDataSource;

    private RecensioneDAO recensioneDAO;
    private FilmDAO filmDAO;
    private ValutazioneDAO valutazioneDAO;
    private RecensioniService recensioniService;

    @BeforeAll
    static void beforeAll() {
        BasicDataSource ds = new BasicDataSource();
        ds.setDriverClassName("com.mysql.cj.jdbc.Driver");
        ds.setUrl("jdbc:mysql://localhost:3306/RatedDB");
        ds.setUsername("root");
        ds.setPassword("root");
        ds.setInitialSize(1);
        ds.setMaxTotal(5);

        testDataSource = ds;
    }

    @BeforeEach
    void setUp() {
        recensioneDAO = new RecensioneDAO(testDataSource);
        filmDAO = new FilmDAO(testDataSource);
        valutazioneDAO = new ValutazioneDAO(testDataSource);

        recensioniService = new RecensioniService(recensioneDAO, valutazioneDAO, null, filmDAO);
    }


    @Test
    void testAddRecensione_Valid_ShouldCreateAndUpdateFilmRating() {
        FilmBean film = new FilmBean();
        film.setNome("FilmTest");
        filmDAO.save(film);

        recensioniService.addRecensione("alice@example.com", film.getIdFilm(), "Ottimo film", "Recensione Alice", 5);

        RecensioneBean rec = recensioneDAO.findById("alice@example.com", film.getIdFilm());
        assertNotNull(rec);
        assertEquals("Recensione Alice", rec.getTitolo());
        assertEquals(5, rec.getValutazione());

        FilmBean updatedFilm = filmDAO.findById(film.getIdFilm());
        assertEquals(5, updatedFilm.getValutazione());
    }

    @Test
    void testAddRecensione_Duplicate_ShouldNotCreate() {
        FilmBean film = new FilmBean();
        film.setNome("Film DoubleRec");
        filmDAO.save(film);

        recensioniService.addRecensione("bob@example.com", film.getIdFilm(), "Prima", "Titolo1", 3);
        // Riprovo con la stessa email + stesso film
        recensioniService.addRecensione("bob@example.com", film.getIdFilm(), "Seconda", "Titolo2", 5);

        List<RecensioneBean> recs = recensioneDAO.findByIdFilm(film.getIdFilm());
        assertEquals(1, recs.size());
        assertEquals("Prima", recs.get(0).getContenuto());
    }

    @Test
    void testAddValutazione_NewLike_ShouldIncrementNLike() {
        FilmBean film = new FilmBean();
        film.setNome("FilmLikeTest");
        filmDAO.save(film);

        recensioniService.addRecensione("y@example.com", film.getIdFilm(), "Rec di Y", "Titolo Rec Y", 3);

        // X mette like
        recensioniService.addValutazione("x@example.com", film.getIdFilm(), "y@example.com", true);

        RecensioneBean recY = recensioneDAO.findById("y@example.com", film.getIdFilm());
        assertEquals(1, recY.getNLike());
        assertEquals(0, recY.getNDislike());
    }

    @Test
    void testDeleteRecensione_ShouldRemoveAndUpdateFilmRating() {
        FilmBean film = new FilmBean();
        film.setNome("FilmDeleteTest");
        filmDAO.save(film);

        recensioniService.addRecensione("alice@example.com", film.getIdFilm(), "Rec Alice", "Tit1", 4);
        recensioniService.addRecensione("bob@example.com", film.getIdFilm(), "Rec Bob", "Tit2", 2);

        recensioniService.deleteRecensione("alice@example.com", film.getIdFilm());

        assertNull(recensioneDAO.findById("alice@example.com", film.getIdFilm()));

        FilmBean updatedFilm = filmDAO.findById(film.getIdFilm());
        assertEquals(2, updatedFilm.getValutazione()); // solo Bob rimane
    }
}

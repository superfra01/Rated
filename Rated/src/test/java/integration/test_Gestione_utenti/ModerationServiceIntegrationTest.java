package integration.test_Gestione_utenti;


import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.*;

import sottosistemi.Gestione_Utenti.service.ModerationService;
import model.DAO.UtenteDAO;
import model.Entity.UtenteBean;

import org.apache.commons.dbcp2.BasicDataSource;
import javax.sql.DataSource;

public class ModerationServiceIntegrationTest {

    private static DataSource testDataSource;

    private UtenteDAO utenteDAO;
    private ModerationService moderationService;

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
        utenteDAO = new UtenteDAO(testDataSource);
        moderationService = new ModerationService(utenteDAO);
    }

    @AfterEach
    void tearDown() {
        // pulizia se necessario
    }

   

    @Test
    void testWarn_UserNotFound() {
        // Se la logica prevede un'eccezione
        assertThrows(NullPointerException.class, () -> {
            moderationService.warn("non.esiste@example.com");
        });
    }
}

package integration.test_Gestione_utenti;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.*;

import sottosistemi.Gestione_Utenti.service.AutenticationService;
import model.DAO.UtenteDAO;
import model.Entity.UtenteBean;
import utilities.PasswordUtility;

public class AutenticationServiceIntegrationTest {

    private AutenticationService authService;
    private UtenteDAO utenteDAO;

    @BeforeEach
    void setUp() {
        utenteDAO = new UtenteDAO();
        authService = new AutenticationService(utenteDAO);
    }

    @AfterEach
    void tearDown() {
        // pulizia
    }

    @Test
    void testRegister_NewUser_ShouldSucceed() {
        // ESEMPIO “TC07.1”: registrazione con successo
        UtenteBean user = authService.register("NuovoUtente", "nuovo.utente@example.com", 
                                               "passwordSicura123", "Bio di test", null);
        assertNotNull(user, "La registrazione deve restituire un utente non nullo.");
        assertEquals("NuovoUtente", user.getUsername());
        assertEquals("RECENSORE", user.getTipoUtente(), "Tipo utente di default dev’essere 'RECENSORE' in questo scenario.");
    }

    @Test
    void testRegister_ExistingEmail_ShouldFail() {
        // ESEMPIO “TC07.2”: Email già registrata
        UtenteBean existing = new UtenteBean();
        existing.setEmail("alice.rossi@example.com");
        existing.setUsername("alice.rossi");
        existing.setPassword(PasswordUtility.hashPassword("alice123"));
        existing.setTipoUtente("RECENSORE");
        utenteDAO.save(existing);

        // Provo a registrare un nuovo utente con la stessa email
        UtenteBean result = authService.register("NuovoNome", "alice.rossi@example.com", 
                                                 "pass123", "Bio", null);
        assertNull(result, "Se l'email è già presente, la registrazione deve fallire (null).");
    }

    @Test
    void testLogin_CorrectCredentials_ShouldReturnUser() {
        // ESEMPIO “TC08.1”: login corretto
        UtenteBean user = new UtenteBean();
        user.setEmail("chiara.neri@example.com");
        user.setUsername("chiara.neri");
        user.setPassword(PasswordUtility.hashPassword("chiara123"));
        user.setTipoUtente("RECENSORE");
        utenteDAO.save(user);

        // Prova login
        UtenteBean loggedUser = authService.login("chiara.neri@example.com", "chiara123");
        assertNotNull(loggedUser, "Login deve avere successo.");
        assertEquals("chiara.neri", loggedUser.getUsername());
    }

    @Test
    void testLogin_WrongPassword_ShouldReturnNull() {
        // ESEMPIO “TC08.4”: password errata
        UtenteBean user = new UtenteBean();
        user.setEmail("alice.rossi@example.com");
        user.setUsername("alice.rossi");
        user.setPassword(PasswordUtility.hashPassword("alice123"));
        utenteDAO.save(user);

        // Prova login con password errata
        UtenteBean result = authService.login("alice.rossi@example.com", "wrongPass");
        assertNull(result, "Login deve fallire con password sbagliata.");
    }

    
}

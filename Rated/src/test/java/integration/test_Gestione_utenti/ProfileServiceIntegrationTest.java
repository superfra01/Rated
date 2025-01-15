package integration.test_Gestione_utenti;


import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.*;

import sottosistemi.Gestione_Utenti.service.ProfileService;
import model.DAO.UtenteDAO;
import model.Entity.UtenteBean;

import org.apache.commons.dbcp2.BasicDataSource;
import javax.sql.DataSource;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import model.Entity.RecensioneBean;

public class ProfileServiceIntegrationTest {

    private static DataSource testDataSource;

    private UtenteDAO utenteDAO;
    private ProfileService profileService;

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
        profileService = new ProfileService(testDataSource);
    }

    @AfterEach
    void tearDown() {
        // pulizia se necessario
    }

    @Test
    void testProfileUpdate_Success() {
        // Creo un utente esistente
        String email = "test@example.com";
        UtenteBean existingUser = new UtenteBean();
        existingUser.setEmail(email);
        existingUser.setUsername("olduser");
        existingUser.setPassword("oldpass");
        existingUser.setBiografia("vecchia bio");
        utenteDAO.save(existingUser);

        // Modifichiamo
        String newUsername = "newUsername";
        String newPassword = "newPassword";
        String newBio = "New biography";
        byte[] icon = new byte[]{1,2,3};

        UtenteBean updatedUser = profileService.ProfileUpdate(newUsername, email, newPassword, newBio, icon);

        assertNotNull(updatedUser);
        assertEquals(newUsername, updatedUser.getUsername());
        assertEquals(newPassword, updatedUser.getPassword());
        assertEquals(newBio, updatedUser.getBiografia());
        assertArrayEquals(icon, updatedUser.getIcona());
    }

    @Test
    void testProfileUpdate_UsernameAlreadyExists() {
        // Creo due utenti
        UtenteBean userA = new UtenteBean();
        userA.setEmail("a@example.com");
        userA.setUsername("UserA");
        userA.setPassword("passA");
        utenteDAO.save(userA);

        UtenteBean userB = new UtenteBean();
        userB.setEmail("b@example.com");
        userB.setUsername("UserB");
        userB.setPassword("passB");
        utenteDAO.save(userB);

        // B cerca di cambiare username in "UserA" (già preso)
        UtenteBean result = profileService.ProfileUpdate("UserA", "b@example.com", "passB", "Bio", null);
        assertNull(result, "Se l'username è già in uso, il metodo ritorna null.");
    }

    @Test
    void testPasswordUpdate_Success() {
        String email = "pw@example.com";
        UtenteBean user = new UtenteBean();
        user.setEmail(email);
        user.setUsername("pwUser");
        user.setPassword("oldPass");
        utenteDAO.save(user);

        String newPassword = "newPass";
        UtenteBean updated = profileService.PasswordUpdate(email, newPassword);
        assertNotNull(updated);
        assertEquals(newPassword, updated.getPassword());
    }

    @Test
    void testPasswordUpdate_UserNotFound() {
        UtenteBean result = profileService.PasswordUpdate("nonexistent@example.com", "pass");
        assertNull(result);
    }

    @Test
    void testGetUsers() {
        // Simuliamo qualche recensione
        List<RecensioneBean> recensioni = new ArrayList<>();

        RecensioneBean r1 = new RecensioneBean();
        r1.setEmail("mail1@example.com");
        RecensioneBean r2 = new RecensioneBean();
        r2.setEmail("mail2@example.com");
        recensioni.add(r1);
        recensioni.add(r2);

        // Creiamo due utenti
        UtenteBean user1 = new UtenteBean();
        user1.setEmail("mail1@example.com");
        user1.setUsername("user1");
        utenteDAO.save(user1);

        UtenteBean user2 = new UtenteBean();
        user2.setEmail("mail2@example.com");
        user2.setUsername("user2");
        utenteDAO.save(user2);

        HashMap<String, String> usersMap = profileService.getUsers(recensioni);

        assertEquals(2, usersMap.size());
        assertEquals("user1", usersMap.get("mail1@example.com"));
        assertEquals("user2", usersMap.get("mail2@example.com"));
    }
}

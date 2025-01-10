package sottosistemi.Gestione_Utenti.service;

import model.DAO.UtenteDAO;
import model.Entity.UtenteBean;
import utilities.PasswordUtility;

import java.sql.SQLException;

import javax.servlet.http.HttpSession;


public class AutenticationService {
    private UtenteDAO UtenteDAO;
    

    public AutenticationService() {
        this.UtenteDAO = new UtenteDAO();
        
    }
    
    


    public UtenteBean login(String email, String password) {
    	
        UtenteBean user = UtenteDAO.findByEmail(email);
        if (user != null && PasswordUtility.hashPassword(user.getPassword()).equals(password)) {
            return user; // Authentication successful
        }
        
        return null; // Authentication failed
    }

    public void logout(HttpSession session) {
        session.invalidate();
    }
    
    public UtenteBean register(String username, String email, String password, String biografia, byte[] icon) {
    	
    	// Check if the user already exists
        if (UtenteDAO.findByEmail(email) != null) {
            return null; // User already exists
        }
        
        // Check if the user already exists
        if (UtenteDAO.findByUsername(username) != null) {
            return null; // User already exists
        }
    	
    	
    	UtenteBean User = new UtenteBean();
        User.setUsername(username);
        User.setEmail(email);
        User.setPassword(PasswordUtility.hashPassword(password));
        User.setTipoUtente("RECENSORE");
        User.setIcona(icon);
        User.setNWarning(0);
        
        
        UtenteDAO.save(User);
        
        return User;
    }
}

package sottosistemi.Gestione_Utenti.service;

import model.DAO.UtenteDAO;
import model.Entity.UtenteBean;



public class ProfileService {
    private UtenteDAO UtenteDAO;
    

    public ProfileService() {
        this.UtenteDAO = new UtenteDAO();
        
    }
    
    public UtenteBean ProfileUpdate(String username, String email, String password, String biografia, byte[] icon) {
    	if(UtenteDAO.findByUsername(username)!=null)
    		return null;
    	UtenteBean user = UtenteDAO.findByEmail(email);
    	user.setUsername(username);
    	user.setPassword(password);
    	user.setBiografia(biografia);
    	user.setIcona(icon);
    	UtenteDAO.update(user);
    	
    	return user;
    }
    
    public UtenteBean PasswordUpdate(String email, String password) {
    	
    	UtenteBean user = UtenteDAO.findByEmail(email);
    	if(user==null)
    		return null;
    	
    	user.setPassword(password);
    	UtenteDAO.update(user);
    	
    	return user;
    }
    
    public void warn(String email) {
    	UtenteBean user = UtenteDAO.findByEmail(email);
    	user.setNWarning(user.getNWarning()+1);
    	UtenteDAO.update(user);
    	
    	
    }
    
    public UtenteBean findByUsername(String username) {
    	return UtenteDAO.findByUsername(username);
    }
    
}

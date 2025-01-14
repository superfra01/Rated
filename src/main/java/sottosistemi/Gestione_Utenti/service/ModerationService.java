package sottosistemi.Gestione_Utenti.service;

import model.DAO.UtenteDAO;
import model.Entity.UtenteBean;

public class ModerationService {
    private UtenteDAO UtenteDAO;
    

    public ModerationService() {
        this.UtenteDAO = new UtenteDAO();
        
    }
    
    public void warn(String email) {
    	UtenteBean user = UtenteDAO.findByEmail(email);
    	user.setNWarning(user.getNWarning()+1);
    	UtenteDAO.update(user);
    	
    	
    }
    
    
    
}
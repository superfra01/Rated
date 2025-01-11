package sottosistemi.Gestione_Recensioni.service;



import java.util.List;

import model.DAO.RecensioneDAO;
import model.Entity.RecensioneBean;
import model.Entity.UtenteBean;

public class RecensioniService {
    private RecensioneDAO RecensioneDAO;
    

    public RecensioniService() {
        this.RecensioneDAO = new RecensioneDAO();
        
    }
    
    public List<RecensioneBean> FindRecensioni(String email) {
    	
    	List<RecensioneBean> recensioni = RecensioneDAO.findByUser(email);
    	
    	
    	return recensioni;
    }
    
    
}
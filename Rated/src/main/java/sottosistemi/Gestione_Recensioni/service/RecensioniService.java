package sottosistemi.Gestione_Recensioni.service;



import java.util.List;

import model.DAO.RecensioneDAO;
import model.Entity.RecensioneBean;

public class RecensioniService {
    private RecensioneDAO RecensioneDAO;
    

    public RecensioniService() {
        this.RecensioneDAO = new RecensioneDAO();
        
    }
    
    public List<RecensioneBean> FindRecensioni(String email) {
    	
    	List<RecensioneBean> recensioni = RecensioneDAO.findByUser(email);
    	
    	
    	return recensioni;
    }
    
    public void deleteRecensione(String email, int ID_Film) {
    	RecensioneDAO.delete(email, ID_Film);
    }
    
    
}
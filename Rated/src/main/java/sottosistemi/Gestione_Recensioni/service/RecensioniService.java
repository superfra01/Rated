package sottosistemi.Gestione_Recensioni.service;



import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import model.DAO.RecensioneDAO;
import model.DAO.ReportDAO;
import model.Entity.RecensioneBean;
import model.Entity.ValutazioneBean;
import model.DAO.ValutazioneDAO;

public class RecensioniService {
    private RecensioneDAO RecensioneDAO;
    private ValutazioneDAO ValutazioneDAO;
    private ReportDAO ReportDAO;
    

    public RecensioniService() {
        this.RecensioneDAO = new RecensioneDAO();
        this.ValutazioneDAO = new ValutazioneDAO();
        this.ReportDAO = new ReportDAO();
        
    }
    public void addValutazione(String email, int idFilm, String email_recensore, boolean valutazione) {
    	
    	ValutazioneBean ValutazioneBean = new ValutazioneBean();
    	ValutazioneBean.setEmail(email);
    	ValutazioneBean.setEmailRecensore(email_recensore);
    	ValutazioneBean.setIdFilm(idFilm);
    	ValutazioneBean.setLikeDislike(valutazione);
    	
    	ValutazioneDAO.save(ValutazioneBean);
    	
    	
    }
    public List<RecensioneBean> FindRecensioni(String email) {
    	
    	List<RecensioneBean> recensioni = RecensioneDAO.findByUser(email);
    	
    	
    	return recensioni;
    }
    
    public void deleteRecensione(String email, int ID_Film) {
    	RecensioneDAO.delete(email, ID_Film);
    	ValutazioneDAO.deleteValutazioni( email, ID_Film);
    	ReportDAO.deleteReports(email, ID_Film);
    }
    
    public void deleteReports(String email, int ID_Film) {
    	RecensioneBean recensione = RecensioneDAO.findById(email, ID_Film);
    	recensione.setNReports(0);
    	RecensioneDAO.update(recensione);
    	
    	ReportDAO.deleteReports(email, ID_Film);
    }
    
    public List<RecensioneBean> GetRecensioni(int ID_film){
    	
    	return RecensioneDAO.findByIdFilm(ID_film);
    	
    }
    
    public HashMap<String, ValutazioneBean> GetValutazioni(int ID_film, String email){
    	
    	return ValutazioneDAO.findByIdFilmAndEmail(ID_film, email);
    	
    }
    
    public List<RecensioneBean> GetAllRecensioniSegnalate(){
    	List<RecensioneBean> recensioni = RecensioneDAO.findAll();
    	List<RecensioneBean> recensioniFiltered = new ArrayList<RecensioneBean>();
    	for(RecensioneBean recensione : recensioni)
    		if(recensione.getNReports()!=0)
    			recensioniFiltered.add(recensione);
    	
    		
    	
    	return recensioniFiltered;
    	
    }
    
    
}
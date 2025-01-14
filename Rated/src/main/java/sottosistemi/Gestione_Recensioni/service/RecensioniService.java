package sottosistemi.Gestione_Recensioni.service;



import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import model.DAO.RecensioneDAO;
import model.DAO.ReportDAO;
import model.DAO.FilmDAO;
import model.Entity.RecensioneBean;
import model.Entity.ReportBean;
import model.Entity.ValutazioneBean;
import model.Entity.FilmBean;
import model.DAO.ValutazioneDAO;

public class RecensioniService {
    private RecensioneDAO RecensioneDAO;
    private ValutazioneDAO ValutazioneDAO;
    private ReportDAO ReportDAO;
    private FilmDAO FilmDAO;
    

    public RecensioniService() {
        this.RecensioneDAO = new RecensioneDAO();
        this.ValutazioneDAO = new ValutazioneDAO();
        this.ReportDAO = new ReportDAO();
        this.FilmDAO = new FilmDAO();
        
    }
    public synchronized void addValutazione(String email, int idFilm, String email_recensore, boolean nuovaValutazione) {
        // Recupero la valutazione esistente, se presente
        ValutazioneBean valutazioneEsistente = ValutazioneDAO.findById(email, email_recensore, idFilm);
        RecensioneBean recensione = RecensioneDAO.findById(email_recensore, idFilm);

        if (recensione == null) {
            throw new IllegalArgumentException("Recensione non trovata.");
        }

        // Gestione dei contatori in base alla valutazione corrente
        if (valutazioneEsistente != null) {
            boolean valutazioneCorrente = valutazioneEsistente.isLikeDislike();

            // Caso 1: L'utente ha cambiato la valutazione
            if (valutazioneCorrente != nuovaValutazione) {
                if (nuovaValutazione) {
                    recensione.setNLike(recensione.getNLike() + 1);
                    recensione.setNDislike(recensione.getNDislike() - 1);
                } else {
                    recensione.setNLike(recensione.getNLike() - 1);
                    recensione.setNDislike(recensione.getNDislike() + 1);
                }
                valutazioneEsistente.setLikeDislike(nuovaValutazione);
                ValutazioneDAO.save(valutazioneEsistente);
            }
            // Caso 2: L'utente rimuove la valutazione
            else {
                if (valutazioneCorrente) {
                    recensione.setNLike(recensione.getNLike() - 1);
                } else {
                    recensione.setNDislike(recensione.getNDislike() - 1);
                }
                ValutazioneDAO.delete(email, email_recensore, idFilm);
            }
        }
        // Caso 3: Nuova valutazione
        else {
            ValutazioneBean nuovaValutazioneBean = new ValutazioneBean();
            nuovaValutazioneBean.setEmail(email);
            nuovaValutazioneBean.setEmailRecensore(email_recensore);
            nuovaValutazioneBean.setIdFilm(idFilm);
            nuovaValutazioneBean.setLikeDislike(nuovaValutazione);
            ValutazioneDAO.save(nuovaValutazioneBean);

            if (nuovaValutazione) {
                recensione.setNLike(recensione.getNLike() + 1);
            } else {
                recensione.setNDislike(recensione.getNDislike() + 1);
            }
        }

        // Aggiornamento della recensione nel database
        RecensioneDAO.update(recensione);
    }
    
    public synchronized void addRecensione(String email, int idFilm, String recensione, String Titolo, int valutazione) {
    	
    	if(RecensioneDAO.findById(email, idFilm)!=null)
    		return;
    	
    	RecensioneBean RecensioneBean = new RecensioneBean();
    	RecensioneBean.setEmail(email);
    	RecensioneBean.setTitolo(Titolo);
    	RecensioneBean.setIdFilm(idFilm);
    	RecensioneBean.setContenuto(recensione);
    	RecensioneBean.setTitolo(Titolo);
    	RecensioneBean.setValutazione(valutazione);
    	RecensioneDAO.save(RecensioneBean);
    	
    	FilmBean film = FilmDAO.findById(idFilm);
    	List<RecensioneBean> recensioni = RecensioneDAO.findByIdFilm(idFilm);
    	int somma=0;
    	for(RecensioneBean recensionefilm: recensioni)
    		somma+=recensionefilm.getValutazione();
    	int media= somma/recensioni.size();
    	film.setValutazione(media);
    	FilmDAO.update(film);
    	
    	
    }
    public List<RecensioneBean> FindRecensioni(String email) {
    	
    	List<RecensioneBean> recensioni = RecensioneDAO.findByUser(email);
    	
    	
    	return recensioni;
    }
    
    public synchronized void deleteRecensione(String email, int ID_Film) {
    	RecensioneDAO.delete(email, ID_Film);
    	ValutazioneDAO.deleteValutazioni( email, ID_Film);
    	ReportDAO.deleteReports(email, ID_Film);
    	
    	FilmBean film = FilmDAO.findById(ID_Film);
    	List<RecensioneBean> recensioni = RecensioneDAO.findByIdFilm(ID_Film);
    	int somma=0;
    	for(RecensioneBean recensionefilm: recensioni)
    		somma+=recensionefilm.getValutazione();
    	int media= somma/recensioni.size();
    	film.setValutazione(media);
    	FilmDAO.update(film);
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
    
    public synchronized void report(String email, String emailRecensore,int idFilm) {
    	
    	ReportBean report = new ReportBean();
    	report.setEmailRecensore(emailRecensore);
    	report.setEmail(email);
    	report.setIdFilm(idFilm);
    	if(ReportDAO.findById(email, emailRecensore, idFilm)==null)
    		ReportDAO.save(report);
    	
    }
    
    
}
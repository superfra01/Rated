package sottosistemi.Gestione_Film.service;

import model.DAO.FilmDAO;

import model.Entity.FilmBean;
import model.Entity.RecensioneBean;

import java.util.HashMap;
import java.util.List;


public class CatalogoService {
    private FilmDAO FilmDAO;
    

    public CatalogoService() {
        this.FilmDAO = new FilmDAO();
        
    }
    
    public List<FilmBean> getFilms(){
    	List<FilmBean> films = FilmDAO.findAll();
    	return films;
    }

    public void aggiungiFilm(String nome, int anno, int durata, String generi, String regista, String attori, byte[] locandina) {
        FilmBean film = new FilmBean();
        film.setNome(nome);
        film.setAnno(anno);
        film.setDurata(durata);
        film.setGeneri(generi);
        film.setRegista(regista);
        film.setAttori(attori);
        film.setLocandina(locandina);
        FilmDAO.save(film);
    }

    public void rimuoviFilm(FilmBean film) {
        FilmDAO.delete(film.getIdFilm());
    }

    public List<FilmBean> ricercaFilm(String name) {
        return FilmDAO.findByName(name);
    }

    public FilmBean getFilm(int idFilm) {
        return FilmDAO.findById(idFilm);
    }
    
    public HashMap<Integer, FilmBean> getFilms(List<RecensioneBean> recensioni) {
    	
    	HashMap<Integer, FilmBean> FilmMap = new HashMap<>();
    	for(RecensioneBean Recensione:recensioni) {
    		CatalogoService CatalogoService = new CatalogoService();
    		int key = Recensione.getIdFilm();
    		FilmBean Film = CatalogoService.getFilm(key);
    		FilmMap.put(key, Film);
    	}
        return FilmMap;
    }
    
    public void addFilm(int anno, String Attori, int durata, String Generi, byte[] Locandina, String Nome, String Regista){
    	FilmBean film = new FilmBean();
    	film.setAnno(anno);
    	film.setAttori(Attori);
    	film.setDurata(durata);
    	film.setGeneri(Generi);
    	film.setLocandina(Locandina);
    	film.setNome(Nome);
    	film.setRegista(Regista);
    	FilmDAO.save(film);
    }
}

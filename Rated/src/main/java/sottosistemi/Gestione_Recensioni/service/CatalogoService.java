package sottosistemi.Gestione_Recensioni.service;

import model.DAO.FilmDAO;

import model.Entity.FilmBean;


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
}

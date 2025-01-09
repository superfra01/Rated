package model.Entity;

import java.io.Serializable;

public class FilmBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idFilm;
    private byte[] locandina;
    private String nome;
    private int anno;
    private int durata;
    private String generi;
    private String regista;
    private String attori;

    public FilmBean() {
        idFilm = 0;
        locandina = null;
        nome = "";
        anno = 0;
        durata = 0;
        generi = "";
        regista = "";
        attori = "";
    }

    public FilmBean(int idFilm, byte[] locandina, String nome, int anno, int durata, String generi, String regista, String attori) {
        this.idFilm = idFilm;
        this.locandina = locandina;
        this.nome = nome;
        this.anno = anno;
        this.durata = durata;
        this.generi = generi;
        this.regista = regista;
        this.attori = attori;
    }

    public int getIdFilm() {
        return idFilm;
    }

    public void setIdFilm(int idFilm) {
        this.idFilm = idFilm;
    }

    public byte[] getLocandina() {
        return locandina;
    }

    public void setLocandina(byte[] locandina) {
        this.locandina = locandina;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public int getAnno() {
        return anno;
    }

    public void setAnno(int anno) {
        this.anno = anno;
    }

    public int getDurata() {
        return durata;
    }

    public void setDurata(int durata) {
        this.durata = durata;
    }

    public String getGeneri() {
        return generi;
    }

    public void setGeneri(String generi) {
        this.generi = generi;
    }

    public String getRegista() {
        return regista;
    }

    public void setRegista(String regista) {
        this.regista = regista;
    }

    public String getAttori() {
        return attori;
    }

    public void setAttori(String attori) {
        this.attori = attori;
    }
}
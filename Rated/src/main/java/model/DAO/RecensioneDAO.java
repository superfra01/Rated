package model.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import model.Entity.RecensioneBean;

public class RecensioneDAO {

    private DataSource dataSource;

    public RecensioneDAO() {
        try {
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            this.dataSource = (DataSource) envCtx.lookup("jdbc/RatedDB");
        } catch (NamingException e) {
            throw new RuntimeException("Error initializing DataSource: " + e.getMessage());
        }
    }

    public void save(RecensioneBean recensione) {
        String query = "INSERT INTO Recensione (titolo, contenuto, valutazione, nLike, nDislike, nReports, email, idFilm) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, recensione.getTitolo());
            ps.setString(2, recensione.getContenuto());
            ps.setInt(3, recensione.getValutazione());
            ps.setInt(4, recensione.getNLike());
            ps.setInt(5, recensione.getNDislike());
            ps.setInt(6, recensione.getNReports());
            ps.setString(7, recensione.getEmail());
            ps.setInt(8, recensione.getIdFilm());
            ps.executeUpdate();
        }catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public RecensioneBean findById(String email, int idFilm)  {
        String query = "SELECT * FROM Recensione WHERE email = ? AND idFilm = ?";
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, email);
            ps.setInt(2, idFilm);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    RecensioneBean recensione = new RecensioneBean();
                    recensione.setTitolo(rs.getString("titolo"));
                    recensione.setContenuto(rs.getString("contenuto"));
                    recensione.setValutazione(rs.getInt("valutazione"));
                    recensione.setNLike(rs.getInt("nLike"));
                    recensione.setNDislike(rs.getInt("nDislike"));
                    recensione.setNReports(rs.getInt("nReports"));
                    recensione.setEmail(rs.getString("email"));
                    recensione.setIdFilm(rs.getInt("idFilm"));
                    return recensione;
                }
            }
        }catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<RecensioneBean> findAll() throws SQLException {
        String query = "SELECT * FROM Recensione";
        List<RecensioneBean> recensioni = new ArrayList<>();
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RecensioneBean recensione = new RecensioneBean();
                recensione.setTitolo(rs.getString("titolo"));
                recensione.setContenuto(rs.getString("contenuto"));
                recensione.setValutazione(rs.getInt("valutazione"));
                recensione.setNLike(rs.getInt("nLike"));
                recensione.setNDislike(rs.getInt("nDislike"));
                recensione.setNReports(rs.getInt("nReports"));
                recensione.setEmail(rs.getString("email"));
                recensione.setIdFilm(rs.getInt("idFilm"));
                recensioni.add(recensione);
            }
        }
        return recensioni;
    }
    
    public List<RecensioneBean> findByUser(String email) {
        String query = "SELECT * FROM Recensione WHERE email = ?";
        List<RecensioneBean> recensioni = new ArrayList<>();
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RecensioneBean recensione = new RecensioneBean();
                    recensione.setTitolo(rs.getString("titolo"));
                    recensione.setContenuto(rs.getString("contenuto"));
                    recensione.setValutazione(rs.getInt("valutazione"));
                    recensione.setNLike(rs.getInt("nLike"));
                    recensione.setNDislike(rs.getInt("nDislike"));
                    recensione.setNReports(rs.getInt("nReports"));
                    recensione.setEmail(rs.getString("email"));
                    recensione.setIdFilm(rs.getInt("idFilm"));
                    recensioni.add(recensione);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recensioni;
    }
    
    public void update(RecensioneBean recensione) throws SQLException {
        String query = "UPDATE Recensione SET titolo = ?, contenuto = ?, valutazione = ?, nLike = ?, nDislike = ?, nReports = ? WHERE email = ? AND idFilm = ?";
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, recensione.getTitolo());
            ps.setString(2, recensione.getContenuto());
            ps.setInt(3, recensione.getValutazione());
            ps.setInt(4, recensione.getNLike());
            ps.setInt(5, recensione.getNDislike());
            ps.setInt(6, recensione.getNReports());
            ps.setString(7, recensione.getEmail());
            ps.setInt(8, recensione.getIdFilm());
            ps.executeUpdate();
        }
    }

    public void delete(String email, int idFilm) {
        String query = "DELETE FROM Recensione WHERE email = ? AND idFilm = ?";
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, email);
            ps.setInt(2, idFilm);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

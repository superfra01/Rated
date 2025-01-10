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
import model.Entity.ValutazioneBean;

public class ValutazioneDAO {

    private DataSource dataSource;

    public ValutazioneDAO() {
        try {
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            this.dataSource = (DataSource) envCtx.lookup("jdbc/RatedDB");
        } catch (NamingException e) {
            throw new RuntimeException("Error initializing DataSource: " + e.getMessage());
        }
    }

    public void save(ValutazioneBean valutazione) {
        String query = "INSERT INTO Valutazione (likeDislike, email, emailRecensore, idFilm) VALUES (?, ?, ?, ?)";
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setBoolean(1, valutazione.isLikeDislike());
            ps.setString(2, valutazione.getEmail());
            ps.setString(3, valutazione.getEmailRecensore());
            ps.setInt(4, valutazione.getIdFilm());
            ps.executeUpdate();
        }catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public ValutazioneBean findById(String email, String emailRecensore, int idFilm) {
        String query = "SELECT * FROM Valutazione WHERE email = ? AND emailRecensore = ? AND idFilm = ?";
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, email);
            ps.setString(2, emailRecensore);
            ps.setInt(3, idFilm);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ValutazioneBean valutazione = new ValutazioneBean();
                    valutazione.setLikeDislike(rs.getBoolean("likeDislike"));
                    valutazione.setEmail(rs.getString("email"));
                    valutazione.setEmailRecensore(rs.getString("emailRecensore"));
                    valutazione.setIdFilm(rs.getInt("idFilm"));
                    return valutazione;
                }
            }
        }catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void delete(String email, String emailRecensore, int idFilm) {
        String query = "DELETE FROM Valutazione WHERE email = ? AND emailRecensore = ? AND idFilm = ?";
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, email);
            ps.setString(2, emailRecensore);
            ps.setInt(3, idFilm);
            ps.executeUpdate();
        }catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
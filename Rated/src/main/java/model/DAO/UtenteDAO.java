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
import model.Entity.UtenteBean;

public class UtenteDAO {

    private DataSource dataSource;

    public UtenteDAO() {
        try {
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            this.dataSource = (DataSource) envCtx.lookup("jdbc/RatedDB");
        } catch (NamingException e) {
            throw new RuntimeException("Error initializing DataSource: " + e.getMessage());
        }
    }

    public void save(UtenteBean utente) throws SQLException {
        String query = "INSERT INTO Utente (email, icona, username, password, tipoUtente, nWarning) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, utente.getEmail());
            ps.setBytes(2, utente.getIcona());
            ps.setString(3, utente.getUsername());
            ps.setString(4, utente.getPassword());
            ps.setString(5, utente.getTipoUtente());
            ps.setInt(6, utente.getNWarning());
            ps.executeUpdate();
        }
    }

    public UtenteBean findByEmail(String email) throws SQLException {
        String query = "SELECT * FROM Utente WHERE email = ?";
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    UtenteBean utente = new UtenteBean();
                    utente.setEmail(rs.getString("email"));
                    utente.setIcona(rs.getBytes("icona"));
                    utente.setUsername(rs.getString("username"));
                    utente.setPassword(rs.getString("password"));
                    utente.setTipoUtente(rs.getString("tipoUtente"));
                    utente.setNWarning(rs.getInt("nWarning"));
                    return utente;
                }
            }
        }
        return null;
    }

    public List<UtenteBean> findAll() throws SQLException {
        String query = "SELECT * FROM Utente";
        List<UtenteBean> utenti = new ArrayList<>();
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                UtenteBean utente = new UtenteBean();
                utente.setEmail(rs.getString("email"));
                utente.setIcona(rs.getBytes("icona"));
                utente.setUsername(rs.getString("username"));
                utente.setPassword(rs.getString("password"));
                utente.setTipoUtente(rs.getString("tipoUtente"));
                utente.setNWarning(rs.getInt("nWarning"));
                utenti.add(utente);
            }
        }
        return utenti;
    }

    public void update(UtenteBean utente) throws SQLException {
        String query = "UPDATE Utente SET icona = ?, username = ?, password = ?, tipoUtente = ?, nWarning = ? WHERE email = ?";
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setBytes(1, utente.getIcona());
            ps.setString(2, utente.getUsername());
            ps.setString(3, utente.getPassword());
            ps.setString(4, utente.getTipoUtente());
            ps.setInt(5, utente.getNWarning());
            ps.setString(6, utente.getEmail());
            ps.executeUpdate();
        }
    }

    public void delete(String email) throws SQLException {
        String query = "DELETE FROM Utente WHERE email = ?";
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, email);
            ps.executeUpdate();
        }
    }
}
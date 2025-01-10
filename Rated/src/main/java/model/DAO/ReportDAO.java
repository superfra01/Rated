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
import model.Entity.ReportBean;

public class ReportDAO {

    private DataSource dataSource;

    public ReportDAO() {
        try {
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            this.dataSource = (DataSource) envCtx.lookup("jdbc/RatedDB");
        } catch (NamingException e) {
            throw new RuntimeException("Error initializing DataSource: " + e.getMessage());
        }
    }

    public void save(ReportBean report) throws SQLException {
        String query = "INSERT INTO Report (email, emailRecensore, idFilm) VALUES (?, ?, ?)";
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, report.getEmail());
            ps.setString(2, report.getEmailRecensore());
            ps.setInt(3, report.getIdFilm());
            ps.executeUpdate();
        }
    }

    public ReportBean findById(String email, String emailRecensore, int idFilm) throws SQLException {
        String query = "SELECT * FROM Report WHERE email = ? AND emailRecensore = ? AND idFilm = ?";
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, email);
            ps.setString(2, emailRecensore);
            ps.setInt(3, idFilm);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ReportBean report = new ReportBean();
                    report.setEmail(rs.getString("email"));
                    report.setEmailRecensore(rs.getString("emailRecensore"));
                    report.setIdFilm(rs.getInt("idFilm"));
                    return report;
                }
            }
        }
        return null;
    }

    public void delete(String email, String emailRecensore, int idFilm) throws SQLException {
        String query = "DELETE FROM Report WHERE email = ? AND emailRecensore = ? AND idFilm = ?";
        try (Connection connection = dataSource.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, email);
            ps.setString(2, emailRecensore);
            ps.setInt(3, idFilm);
            ps.executeUpdate();
        }
    }
}

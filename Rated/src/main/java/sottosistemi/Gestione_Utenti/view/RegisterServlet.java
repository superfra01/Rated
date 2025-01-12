package sottosistemi.Gestione_Utenti.view;

import model.Entity.UtenteBean;
import sottosistemi.Gestione_Utenti.service.AutenticationService;
import utilities.FieldValidator;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private AutenticationService authService;

    @Override
    public void init() {
        authService = new AutenticationService();
    }

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(req, resp);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String username = request.getParameter("username");
    	String email = request.getParameter("email");
    	String password = request.getParameter("password");
    	String confirmPassword = request.getParameter("confirmPassword");
    	String biography = request.getParameter("biography");
    	String iconParam = request.getParameter("icon"); // Icon come stringa
    	byte[] icon = null;

    	if (iconParam != null) {
    	    icon = iconParam.getBytes(); // Convertire in byte solo se non è null
    	}


        if (FieldValidator.validateUsername(username) &&
            FieldValidator.validateEmail(email) &&
            FieldValidator.validatePassword(password) &&
            password.equals(confirmPassword)) {
        		

            UtenteBean utente = authService.register(username, email, password, biography, icon);

            if (utente != null) {
                response.sendRedirect(request.getContextPath() + "/login"); // Redirect to login after successful registration
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Registration failed. User may already exist.");
            }

        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid form data. Check your inputs.");
        }
    }
}

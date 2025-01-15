package sottosistemi.Gestione_Utenti.view;




import model.Entity.UtenteBean;
import model.Entity.ValutazioneBean;
import model.Entity.FilmBean;
import model.Entity.RecensioneBean;
import sottosistemi.Gestione_Utenti.service.AutenticationService;
import sottosistemi.Gestione_Utenti.service.ProfileService;
import sottosistemi.Gestione_Catalogo.service.CatalogoService;
import sottosistemi.Gestione_Recensioni.service.RecensioniService;
import utilities.FieldValidator;

import java.io.IOException;
import java.util.List;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/profileModify")
public class ProfileModifyServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ProfileService ProfileService;

    @Override
    public void init() {
        ProfileService = new ProfileService();
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    		String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String biography = request.getParameter("biography");
            byte[] icon = request.getParameter("icon").getBytes();

            if (FieldValidator.validateUsername(username) &&
                FieldValidator.validatePassword(password)) {
            	
            	UtenteBean utente = ProfileService.ProfileUpdate(username, email, password, biography, icon);
            	
            	HttpSession session = request.getSession(true);
            	session.setAttribute("user", utente);
            	
                response.sendRedirect(request.getContextPath() + "/profile?visitedUser=" + ((UtenteBean)session.getAttribute("user")).getUsername());
            }
    }
}

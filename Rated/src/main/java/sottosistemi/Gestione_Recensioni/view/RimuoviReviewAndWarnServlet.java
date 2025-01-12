package sottosistemi.Gestione_Recensioni.view;

import model.Entity.UtenteBean;
import model.Entity.ValutazioneBean;
import model.Entity.FilmBean;
import model.Entity.RecensioneBean;
import sottosistemi.Gestione_Utenti.service.AutenticationService;
import sottosistemi.Gestione_Utenti.service.ProfileService;
import sottosistemi.Gestione_Film.service.CatalogoService;
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


@WebServlet("/reportedReviewAndWarn")
public class RimuoviReviewAndWarnServlet extends HttpServlet{
		private static final long serialVersionUID = 1L;
		private RecensioniService RecensioniService;
		private ProfileService ProfileService;

	    @Override
	    public void init() {
	    	RecensioniService = new RecensioniService();
	    	ProfileService = new ProfileService();
	    }

	    @Override
	    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	        
	        
	    }

	    @Override
	    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    	
	    	HttpSession session = request.getSession(true);
	    	UtenteBean user = (UtenteBean) session.getAttribute("user");
	    	if(user.getTipoUtente().equals("GestoreCatalogo")) {
	    		String userEmail = request.getParameter("ReviewUserEmail");
				int idFilm = Integer.parseInt(request.getParameter("idFilm"));
				RecensioniService RecensioniService = new RecensioniService();
				RecensioniService.deleteRecensione(userEmail, idFilm);
				ProfileService.warn(userEmail);
				
			
				
				response.sendRedirect(request.getContextPath() + "/reportedview");
	    	}else {
	    		response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	            response.getWriter().write("Non hai i permessi per effettuare la seguente operazione");
	    	}
			
			
		
	    
	    }
	}

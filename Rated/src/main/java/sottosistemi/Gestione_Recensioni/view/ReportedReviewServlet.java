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

@WebServlet("/moderator")
public class ReportedReviewServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private CatalogoService CatalogoService;
	private RecensioniService RecensioniService;
	private ProfileService ProfileService;

    @Override
    public void init() {
    	CatalogoService = new CatalogoService();
        RecensioniService = new RecensioniService();
        ProfileService = new ProfileService();
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	HttpSession session = request.getSession(true);
    	UtenteBean user = (UtenteBean) session.getAttribute("user");
        if(user != null && "MODERATORE".equals(user.getTipoUtente())) {
        	
        	List<RecensioneBean> recensioni = RecensioniService.GetAllRecensioniSegnalate();
        	session.setAttribute("recensioni", recensioni);
        	
        	
    		HashMap<String, String> utenti = ProfileService.getUsers(recensioni);
    		session.setAttribute("users", utenti);
        	
        	HashMap<Integer, FilmBean> FilmMap = CatalogoService.getFilms(recensioni);
        	session.setAttribute("films", FilmMap);
        	request.getRequestDispatcher("/WEB-INF/jsp/moderator.jsp").forward(request, response);	
        }else {
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("You can't access the profile page unless you are an authenticated moderator.");
        }
        
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
        
    }
}

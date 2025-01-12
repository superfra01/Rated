package sottosistemi.Gestione_Utenti.view;


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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	

    @Override
    public void init() {
        
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	HttpSession session = request.getSession(true);
    	UtenteBean user = (UtenteBean) session.getAttribute("visitedUser");
        if(user!=null) {
        	
        	RecensioniService RecensioniService = new RecensioniService();
        	List<RecensioneBean> recensioni = RecensioniService.FindRecensioni(user.getEmail());
        	session.setAttribute("recensioni", recensioni);
        	CatalogoService CatalogoService = new CatalogoService();
        	HashMap<Integer, FilmBean> FilmMap = CatalogoService.getFilms(recensioni);
        	session.setAttribute("films", FilmMap);
        	request.getRequestDispatcher("/WEB-INF/jsp/profile.jsp").forward(request, response);	
        }else {
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("You can't access the profile page if you are not autenticated");
        }
        
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
        
    }
}

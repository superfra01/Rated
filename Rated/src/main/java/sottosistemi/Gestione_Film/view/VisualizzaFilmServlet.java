package sottosistemi.Gestione_Film.view;


import model.Entity.FilmBean;
import sottosistemi.Gestione_Film.service.CatalogoService;


import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/film")
public class VisualizzaFilmServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private CatalogoService CatalogoService;

    @Override
    public void init() {
        CatalogoService = new CatalogoService();
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	HttpSession session = request.getSession(true);
    	String filmName = request.getParameter("idFilm");
    	
    	FilmBean films = CatalogoService.getFilm();
    	session.setAttribute("films", films);
    	
        
        request.getRequestDispatcher("/WEB-INF/jsp/catalogo.jsp").forward(request, response);
        
        
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
        
    }
}

package sottosistemi.Gestione_Film.view;

import model.Entity.UtenteBean;
import sottosistemi.Gestione_Film.service.CatalogoService;


import java.io.IOException;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/filmModify")
public class ModificaFilmServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private CatalogoService CatalogoService;

    @Override
    public void init() {
        CatalogoService = new CatalogoService();
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	HttpSession session = request.getSession(true);
    	UtenteBean user = (UtenteBean) session.getAttribute("user");
    	if(user.getTipoUtente().equals("GestoreCatalogo")) {
    		
    		int idFilm = Integer.parseInt(request.getParameter("idFilm"));
    		int anno = Integer.parseInt(request.getParameter("annoFilm"));
    		String Attori = request.getParameter("attoriFilm");
    		int durata = Integer.parseInt(request.getParameter("durataFilm"));
    		String Generi = request.getParameter("generiFilm");
    		byte[] Locandina = request.getParameter("locandinaFilm").getBytes();
    		String Nome = request.getParameter("nomeFilm");
    		String Regista = request.getParameter("registaFilm");
    		
    		CatalogoService.modifyFilm(idFilm, anno, Attori, durata, Generi, Locandina, Nome, Regista);
    		request.getRequestDispatcher("/WEB-INF/jsp/catalogo").forward(request, response);
    	}else {
    		response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Non hai i permessi per effettuare la seguente operazione");
    	}
    }
}


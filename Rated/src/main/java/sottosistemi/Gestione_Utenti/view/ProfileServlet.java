package sottosistemi.Gestione_Utenti.view;


import model.Entity.UtenteBean;
import sottosistemi.Gestione_Utenti.service.AutenticationService;
import sottosistemi.Gestione_Utenti.service.ProfileService;
import sottosistemi.Gestione_Recensioni.service.RecensoniService;
import utilities.FieldValidator;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ProfileService ProfileService;

    @Override
    public void init() {
        ProfileService = new ProfileService();
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	HttpSession session = request.getSession(true);
        if(session.getAttribute("user")!=null) {
        	RecensoniService RecensoniService = new RecensoniService();
        	List<RecensioneBean> recensioni = RecensoniService
        	session.setAttribute("recensioni", recensioni);
        	request.getRequestDispatcher("/WEB-INF/jsp/profile.jsp").forward(request, response);	
        }else {
        	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("You can't access the profile page if you are not autenticated");
        }
        
        
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	if(request.getParameter("operationType").equals("ProfileModify")) {
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
            	
                response.sendRedirect(request.getContextPath() + "/profile.jsp"); // Redirect to login after successful registration
               
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid form data. Check your inputs.");
            }
    	}else if(request.getParameter("operationType").equals("PasswordModify")) {
    		String email = request.getParameter("email");
            String password = request.getParameter("password");
            if(FieldValidator.validatePassword(password)) {
            	UtenteBean utente = ProfileService.PasswordUpdate(email, password);
            	
            	HttpSession session = request.getSession(true);
            	session.setAttribute("user", utente);
            	
            	response.sendRedirect(request.getContextPath() + "/profile.jsp");
            }
    	}
        
    }
}

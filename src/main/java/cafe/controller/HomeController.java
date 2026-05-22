package cafe.controller;

import cafe.repository.ProdutoRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {

    @Autowired
    private ProdutoRepository repository;

    @GetMapping("/")
    public String welcome() {
        return "welcome";
    }

    @GetMapping("/principal")
    public String principal(Model model, HttpSession session) {

        if (session.getAttribute("usuarioLogado") == null) {
            return "redirect:/login";
        }

        model.addAttribute("totalProdutos", repository.count());

        return "principal";
    }

    @GetMapping("/estoque")
    public String estoque(Model model, HttpSession session) {

        if (session.getAttribute("usuarioLogado") == null) {
            return "redirect:/login";
        }

        model.addAttribute("produtos", repository.findAll());

        return "estoque";
    }
}
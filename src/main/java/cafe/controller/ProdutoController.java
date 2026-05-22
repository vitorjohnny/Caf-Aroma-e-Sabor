package cafe.controller;

import cafe.model.Produto;
import cafe.repository.ProdutoRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/produtos")
public class ProdutoController {

    @Autowired
    private ProdutoRepository repository;

    private boolean naoLogado(HttpSession session) {
        return session.getAttribute("usuarioLogado") == null;
    }

    @GetMapping
    public String listar(Model model, HttpSession session) {

        if (naoLogado(session)) return "redirect:/login";

        model.addAttribute("produtos", repository.findAll());

        return "produto/lista";
    }

    @GetMapping("/novo")
    public String novo(Model model, HttpSession session) {

        if (naoLogado(session)) return "redirect:/login";

        model.addAttribute("produto", new Produto());
        model.addAttribute("produtos", repository.findAll());

        return "produto/cadastro";
    }

    @PostMapping("/salvar")
    public String salvar(@ModelAttribute Produto produto, HttpSession session) {

        if (naoLogado(session)) return "redirect:/login";

        repository.save(produto);

        return "redirect:/produtos";
    }

    @GetMapping("/excluir/{id}")
    public String excluir(@PathVariable Long id, HttpSession session) {

        if (naoLogado(session)) return "redirect:/login";

        repository.deleteById(id);

        return "redirect:/produtos";
    }
}
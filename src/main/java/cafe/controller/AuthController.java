package cafe.controller;

import cafe.model.Usuario;
import cafe.repository.UsuarioRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;

@Controller
public class AuthController {

    @Autowired
    private UsuarioRepository repository;

    @GetMapping("/login")
    public String loginForm() {
        return "index";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email,
                        @RequestParam String senha,
                        HttpSession session,
                        Model model) {

        Usuario usuario = repository.findByEmailAndSenha(email, senha);

        if (usuario == null) {
            model.addAttribute("erro", "E-mail ou senha inválidos.");
            return "index";
        }

        session.setAttribute("usuarioLogado", usuario);
        return "redirect:/principal";
    }

    @GetMapping("/cadastro")
    public String cadastroForm(Model model) {
        model.addAttribute("usuario", new Usuario());
        return "cadastro-usuario";
    }

    @PostMapping("/cadastro")
    public String cadastrar(@ModelAttribute Usuario usuario,
                            HttpSession session,
                            Model model) {

        if (repository.existsByEmail(usuario.getEmail())) {
            model.addAttribute("erro", "Este e-mail já está cadastrado.");
            return "cadastro-usuario";
        }

        repository.save(usuario);
        session.setAttribute("usuarioLogado", usuario);
        return "redirect:/principal";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}
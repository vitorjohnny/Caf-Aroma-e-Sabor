package cafe.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import cafe.model.Usuario;

public interface UsuarioRepository
        extends JpaRepository<Usuario, Long> {

    Usuario findByEmailAndSenha(String email, String senha);

    boolean existsByEmail(String email);
}
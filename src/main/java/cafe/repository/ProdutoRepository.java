package cafe.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import cafe.model.Produto;

public interface ProdutoRepository
        extends JpaRepository<Produto, Long> {
}
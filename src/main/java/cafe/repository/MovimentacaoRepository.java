package cafe.repository;

import cafe.model.Movimentacao;
import cafe.model.Produto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface MovimentacaoRepository extends JpaRepository<Movimentacao, Long> {

    List<Movimentacao> findByProdutoId(Long produtoId);

    List<Movimentacao> findByProduto(Produto produto);

    @Query("SELECT m FROM Movimentacao m WHERE m.dataMov BETWEEN :dataInicio AND :dataFim")
    List<Movimentacao> findByDataMovBetween(@Param("dataInicio") LocalDateTime dataInicio,
                                             @Param("dataFim") LocalDateTime dataFim);

    @Query("SELECT m FROM Movimentacao m WHERE m.produto.id = :produtoId ORDER BY m.dataMov DESC")
    List<Movimentacao> findMovimentacoesPorProduto(@Param("produtoId") Long produtoId);
}


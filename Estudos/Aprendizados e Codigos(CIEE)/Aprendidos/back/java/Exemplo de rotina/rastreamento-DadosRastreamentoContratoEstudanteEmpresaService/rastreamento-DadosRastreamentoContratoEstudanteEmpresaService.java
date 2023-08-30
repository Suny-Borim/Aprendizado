// package br.org.ciee.kairos.vagas.business.service.contratoestudanteempresa.rastreamento;

import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import br.org.ciee.kairos.vagas.business.model.entity.contrato.ContratoEstudanteEmpresa;
import br.org.ciee.kairos.vagas.business.repository.ContratoEstudanteEmpresaRepository;
@Service
public class DadosRastreamentoContratoEstudanteEmpresaService {
	@Autowired
	private ContratoEstudanteEmpresaRepository contratoEstudanteEmpresaRepository;
	public void atualizaRastreamentoAutomaticoPorId(List<Long> ids) {
		ids.stream().forEach(id -> atualizaRastreamentoAutomaticoPorId(id));
	}
	private void atualizaRastreamentoAutomaticoPorId(Long id) {
		Optional<ContratoEstudanteEmpresa> optContratoEstudanteEmpresa = this.contratoEstudanteEmpresaRepository
				.findById(id);
		if (optContratoEstudanteEmpresa.isPresent()) {
			ContratoEstudanteEmpresa contratoEstudanteEmpresa = optContratoEstudanteEmpresa.get();
			contratoEstudanteEmpresa.getDadosVaga().setRastreamentoAutomatico(Boolean.TRUE);
			this.contratoEstudanteEmpresaRepository.save(contratoEstudanteEmpresa);	
		}
	}
}
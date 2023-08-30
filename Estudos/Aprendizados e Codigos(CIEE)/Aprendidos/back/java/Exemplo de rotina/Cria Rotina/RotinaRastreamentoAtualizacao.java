package br.org.ciee.kairos.rotinas.registro.impl;
import br.org.ciee.kairos.rotinas.registro.RegistroRotinaBase;
import org.quartz.CronScheduleBuilder;
import org.quartz.JobDataMap;
import org.quartz.ScheduleBuilder;
import org.quartz.Trigger;
import org.springframework.stereotype.Component;
@Component
public class RotinaRastreamentoAtualizacao extends RegistroRotinaBase {
    protected RotinaRastreamentoAtualizacao() {
        super("atualiza-dados-rastreamento-contratos", "financeiro");
    }
    @Override
    protected ScheduleBuilder<? extends Trigger> getAgendamento() {
        return CronScheduleBuilder.cronSchedule("0 0 3 1/1 * ? *");
    }
    @Override
    protected JobDataMap getJobData() {
        JobDataMap dataMap = new JobDataMap();
        dataMap.put(PARAMETRO_FILA, "__ambiente__-rotina-atualiza-dados-rastreamento-contratos");
        dataMap.put(PARAMETRO_ARMAZENAR_LOG, true);
        return dataMap;
    }
}
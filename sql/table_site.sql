SELECT 
    j.job_id,
    DATE_FORMAT(l.data_hora_inicio, '%Y-%m-%d') AS data_execucao,
    TIME_FORMAT(l.data_hora_inicio,'%H:%i:%s') as hora_execucao,
    j.job_nome,
    c.nome AS cliente,
    DATE_FORMAT(l.data_hora_fim, '%Y-%m-%d') AS data_hora_fim,
    TIME_FORMAT(SEC_TO_TIME(TIMESTAMPDIFF(SECOND, l.data_hora_inicio, l.data_hora_fim)), '%H:%i:%s') AS tempo_execucao,
    s.status_id,
    s.status_name status
FROM jobs j
JOIN cliente c ON j.cliente_id = c.cliente_id
LEFT JOIN (
    SELECT job_id, log_id, data_hora_inicio, data_hora_fim, status
    FROM log_execucao
    WHERE (job_id, log_id) IN (
        SELECT job_id, MAX(log_id)
        FROM log_execucao
        GROUP BY job_id
    )
) l ON j.job_id = l.job_id
LEFT JOIN log_status s on IFNULL(l.status,1) = s.status_id
;
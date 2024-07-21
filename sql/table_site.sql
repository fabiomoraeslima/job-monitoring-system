select r.job_id
	  ,r.data_execucao
	  ,r.hora_execucao
	  ,r.job_nome
	  ,r.cliente
	  ,r.data_hora_fim
	  ,r.tempo_execucao
	  ,r.status_id
	  ,r.status
	  ,r.mensagem
from (
SELECT 
    j.job_id
   ,CASE WHEN DATE(l.data_hora_inicio) <> CURRENT_DATE 
    		THEN NULL
    	ELSE DATE_FORMAT(l.data_hora_inicio, '%Y-%m-%d') 
	END AS data_execucao
	,CASE WHEN DATE(l.data_hora_inicio) <> CURRENT_DATE 
    		THEN NULL
    	ELSE TIME_FORMAT(l.data_hora_inicio,'%H:%i:%s') 
	END AS hora_execucao
    ,j.job_nome
    ,c.nome AS cliente
    ,CASE WHEN DATE(l.data_hora_inicio) <> CURRENT_DATE 
    		THEN NULL
    	ELSE DATE_FORMAT(l.data_hora_fim, '%Y-%m-%d')
	END AS data_hora_fim
	,CASE WHEN DATE(l.data_hora_inicio) <> CURRENT_DATE 
    		THEN NULL
    	ELSE TIME_FORMAT(SEC_TO_TIME(TIMESTAMPDIFF(SECOND, l.data_hora_inicio, l.data_hora_fim)), '%H:%i:%s')
	END AS tempo_execucao
	,CASE WHEN DATE(l.data_hora_inicio) <> CURRENT_DATE 
    		THEN 1
    	ELSE s.status_id
	END AS status_id
	,CASE WHEN DATE(l.data_hora_inicio) <> CURRENT_DATE 
    		THEN 'Pending'
    	ELSE s.status_name 
	END AS status
	,CASE WHEN DATE(l.data_hora_inicio) <> CURRENT_DATE 
    		THEN NULL
    	ELSE l.mensagem
	END AS mensagem
FROM jobs j
JOIN cliente c ON j.cliente_id = c.cliente_id
LEFT JOIN (
    SELECT job_id, log_id, data_hora_inicio, data_hora_fim, status, mensagem
    FROM log_execucao
    WHERE (job_id, log_id) IN (
        SELECT job_id, MAX(log_id)
        FROM log_execucao
        GROUP BY job_id
    )
) l ON j.job_id = l.job_id
LEFT JOIN log_status s on IFNULL(l.status,1) = s.status_id
) r ORDER BY 
    -- Ordena por um indicador de NULL primeiro (0 para não NULL, 1 para NULL)
    (r.data_execucao IS NULL), COALESCE(r.data_execucao, '1900-01-01') DESC, 
    (r.hora_execucao IS NULL), COALESCE(r.hora_execucao, '00:00:00') DESC;
;
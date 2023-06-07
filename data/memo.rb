# frozen_string_literal: true

require 'pg'

class Memo
  def connect
    @conn = PG.connect(dbname: 'memo')
  end

  def read_all
    @conn.exec('SELECT * FROM memo')
  end

  def read_memo(memo_id)
    @conn.exec_params('SELECT * FROM memo WHERE id=$1', [memo_id])
  end

  def write_memo(memo_id, memo_title, memo_content)
    @conn.exec_params('INSERT INTO memo VALUES ($1, $2, $3)', [memo_id, memo_title, memo_content])
  end

  def update_memo(memo_id, memo_title, memo_content)
    @conn.exec_params('UPDATE memo SET title=$2, content=$3 WHERE id=$1', [memo_id, memo_title, memo_content])
  end

  def delete_memo(memo_id)
    @conn.exec_params('DELETE FROM memo WHERE id=$1', [memo_id])
  end
end

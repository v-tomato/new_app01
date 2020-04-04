class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :email, unique: true
    # usersテーブルのemailカラムにインデックスを追加する為、add_indexというRailsのメソッドを使う
    # インデックス自体は一意性を強制しませんが、オプションでunique: trueを指定することで強制できる
  end
end

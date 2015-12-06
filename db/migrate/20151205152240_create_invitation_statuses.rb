class CreateInvitationStatuses < ActiveRecord::Migration
  def change
    create_table :invitation_statuses do |t|
      t.string :nome, default: 'nVisto'
      t.string :descricao
      t.timestamps
    end

    InvitationStatus.create!([
      { nome: 'nVisto',
        descricao: 'A URL-convite ainda não foi acessada. Este é o valor padrão para novos convites' },
      { nome: 'visto',
        descricao: 'A URL-convite foi acessada, porém divulgação não ocorreu' },
      { nome: 'aceito',
        descricao: 'Convite para divulgação foi aceito. Ou seja, divulgação foi realizada' }
    ])
  end
end

class CorrigindoDadosDasTabelas < ActiveRecord::Migration
  def change
    CustomerInvitation.find_each do |ci|
      pr = ci.try(:photos).try(:first).try(:professional)
      ci.update_attribute(:professional_id, pr.id) if pr.present?

      if ci.recovered?
        aceito = InvitationStatus.find_by_nome('aceito')
        ci.update_attribute(:invitation_status_id, InvitationStatus.find(aceito.id))
      else
        nVisto = InvitationStatus.find_by_nome('nVisto')
        ci.update_attribute(:invitation_status_id, InvitationStatus.find(nVisto.id))
      end
    end
  end
end

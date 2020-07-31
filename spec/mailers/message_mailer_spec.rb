require "rails_helper"

RSpec.describe MessageMailer, type: :mailer do
  let!(:sale_user){create(:sale_user)}
  let!(:buy_user){create(:buy_user)}

  let!(:game){create(:game)}
  let!(:item_genre){create(:item_genre)}
  let!(:item_genre_game){create(:item_genre_game, item_genre: item_genre, game: game, enable: true)}
  let!(:buy_item){create(:buy_item, item_genre: item_genre, game: game)}
  let!(:sale_item){create(:sale_item, item_genre: item_genre, game: game)}
  let!(:buy_user_game_rank){create(:user_game_rank, user: buy_user, game: game)}
  let!(:sale_user_game_rank){create(:user_game_rank, user: sale_user, game: game)}

  let(:item_trade){create(:item_trade, user: sale_user, game: game, buy_item: buy_item, sale_item: sale_item, enable: true, numeric_of_trade_deadline: 1, user_game_rank: sale_user_game_rank)}
  let(:item_trade_queue){create(:item_trade_queue, item_trade: item_trade, user: buy_user).decorate}

  before do
    @item_trade = item_trade
    @item_trade.update(enable_item_trade_queue_id: item_trade_queue.id)
  end

  describe '#send_approve_item_trade' do
    
    subject(:mail) do
      described_class.send_approve_item_trade(item_trade_queue).deliver_now
      ActionMailer::Base.deliveries.last
    end

    context 'when send_mail' do
      it { expect(mail.from.first).to eq('scambio.main@gmail.com') }
      it { expect(mail.to.first).to eq(item_trade_queue.user.email) }
      it { expect(mail.subject).to eq(I18n.t('users.user_message_posts.shared.approve_item_trade.subject')) }
      it { expect(get_message_part(mail, /html/)).to match(/#{I18n.t('users.user_message_posts.shared.approve_item_trade.message')}/) }
      it { expect(get_message_part(mail, /plain/)).to match(/#{I18n.t('users.user_message_posts.shared.approve_item_trade.message')}/) }
    end
  end

  describe '#send_forced_item_trade' do
    
    subject(:mail) do
      described_class.send_forced_item_trade(item_trade_queue).deliver_now
      ActionMailer::Base.deliveries.last
    end

    context 'when send_mail' do
      it { expect(mail.from.first).to eq('scambio.main@gmail.com') }
      it { expect(mail.to.first).to eq(item_trade_queue.user.email) }
      it { expect(mail.subject).to eq(I18n.t('users.user_message_posts.shared.forced_item_trade.subject')) }
      it { expect(get_message_part(mail, /html/)).to match(/#{I18n.t('users.user_message_posts.shared.forced_item_trade.message')}/) }
      it { expect(get_message_part(mail, /plain/)).to match(/#{I18n.t('users.user_message_posts.shared.forced_item_trade.message')}/) }
    end
  end

  describe '#send_reject_item_trade' do
    
    subject(:mail) do
      described_class.send_reject_item_trade(item_trade_queue).deliver_now
      ActionMailer::Base.deliveries.last
    end

    context 'when send_mail' do
      it { expect(mail.from.first).to eq('scambio.main@gmail.com') }
      it { expect(mail.to.first).to eq(item_trade_queue.user.email) }
      it { expect(mail.subject).to eq(I18n.t('users.user_message_posts.shared.reject_item_trade.subject')) }
      it { expect(get_message_part(mail, /html/)).to match(/#{I18n.t('users.user_message_posts.shared.reject_item_trade.message')}/) }
      it { expect(get_message_part(mail, /plain/)).to match(/#{I18n.t('users.user_message_posts.shared.reject_item_trade.message')}/) }
    end
  end

  describe '#send_sell_item_trade' do
    
    subject(:mail) do
      described_class.send_sell_item_trade(item_trade_queue).deliver_now
      ActionMailer::Base.deliveries.last
    end

    context 'when send_mail' do
      it { expect(mail.from.first).to eq('scambio.main@gmail.com') }
      it { expect(mail.to.first).to eq(item_trade_queue.item_trade.user.email) }
      it { expect(mail.subject).to eq(I18n.t('users.user_message_posts.shared.sell_item_trade.subject')) }
      it { expect(get_message_part(mail, /html/)).to match(/#{I18n.t('users.user_message_posts.shared.sell_item_trade.message')}/) }
      it { expect(get_message_part(mail, /plain/)).to match(/#{I18n.t('users.user_message_posts.shared.sell_item_trade.message')}/) }
    end
  end
end

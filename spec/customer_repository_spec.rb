require './spec/spec_helper'

RSpec.describe CustomerRepository do
  let (:customer_1){Customer.new({
                                  :id         => 6,
                                  :first_name => 'Joan',
                                  :last_name  => 'Clarke',
                                  :created_at => Time.now,
                                  :updated_at => Time.now
                                  })}
  let (:customer_2){Customer.new({
                                  :id         => 7,
                                  :first_name => 'Richard',
                                  :last_name  => 'Hammilton',
                                  :created_at => Time.now,
                                  :updated_at => Time.now
                                  })}
  let (:customer_3){Customer.new({
                                  :id         => 8,
                                  :first_name => 'Mike',
                                  :last_name  => 'Lowry',
                                  :created_at => Time.now,
                                  :updated_at => Time.now
                                  })}

  let (:customers){[customer_1, customer_2, customer_3]}
  let (:customer_repo){CustomerRepository.new(customers)}
  
  describe '#iteration 3' do
    it '#initialize will populate the attributes' do
      expect(customer_repo).to be_a(CustomerRepository)
    end
  
    it '#all will return all of the customers' do
      expect(customer_repo.all).to eq([customer_1, customer_2, customer_3])
    end

    it '#find_by_id will return the customer whos id matches id arguement' do
      expect(customer_repo.find_by_id(6)).to eq(customer_1)
    end

    it '#find_all_by_first_name will return all customers with the first name' do
      expect(customer_repo.find_all_by_first_name('Joan')).to eq([customer_1])
      expect(customer_repo.find_all_by_first_name('Larry')).to eq([])
    end
  
    it '#find_all_by_last_name will return all customers with the given last name' do
      expect(customer_repo.find_all_by_last_name('Clarke')).to eq([customer_1])
      expect(customer_repo.find_all_by_last_name('Churchill')).to eq([])
    end
    
    it '#create will create a new customer' do
      expect(customer_repo.all).to eq([customer_1, customer_2, customer_3])
      customer_4 = customer_repo.create(
            :first_name => 'Harry',
            :last_name => 'Potter')
      expect(customer_repo.all).to eq([customer_1, customer_2, customer_3, customer_4])
      expect(customer_4.id).to eq(9)
      expect(customer_4.first_name).to eq('Harry')
      expect(customer_4.last_name).to eq('Potter')
      expect(customer_repo.find_by_id(9)).to eq(customer_4)
    end

    it '#all_ids will return all ids' do
      expect(customer_repo.all_ids).to eq([6, 7, 8])
    end

    it '#update will update the customer names with coorisponding id' do
      expect(customer_repo.find_by_id(6).first_name).to eq('Joan')
      expect(customer_repo.find_by_id(6).last_name).to eq('Clarke')
      expect(customer_repo.find_by_id(7).first_name).to eq('Richard')
      
      customer_repo.update(6, {:id => 6, :first_name => 'Joanee'})
      expect(customer_repo.find_by_id(6).first_name).to eq('Joanee')

      customer_repo.update(6, {:id => 6, :last_name => 'Clark'})
      expect(customer_repo.find_by_id(6).last_name).to eq('Clark')
      
      customer_repo.update(7, {:id => 7, :first_name => 'Rick'})
      expect(customer_repo.find_by_id(7).first_name).to eq('Rick')
    end

    it '#delete will delete a customer' do
      customer_repo.delete(6)
      expect(customer_repo.all).to eq([customer_2, customer_3])
    end
  end
end

require 'rails_helper'

RSpec.describe Company, type: :model do
  describe '会社名' do
    it "会社名があれば有効な状態であること" do
      company = Company.create(
        name: "xxxx建設 株式会社",
        email: "xxxx@gmail.com",
        phone_number: "0312345678"
      )
      expect(company.errors[:name]).to eq []
    end

    it "会社名が無ければ無効な状態であること" do
      company = Company.create(
        name: "",
        email: "xxxx@gmail.com",
        phone_number: "0312345678"
      )
      expect(company.errors[:name]).to include("can't be blank")
    end
  end

  describe 'メールアドレス' do
    it "メールアドレスがあれば有効な状態であること" do
      company = Company.create(
        name: "xxxx建設 株式会社",
        email: "xxxx@gmail.com",
        phone_number: "0312345678"
      )
      expect(company.errors[:email]).to eq []
    end

    it "メールアドレスが無ければ無効な状態であること" do
      company = Company.create(
        name: "xxxx建設 株式会社",
        email: "",
        phone_number: "0312345678"
      )
      expect(company.errors[:email]).to include("can't be blank")
    end

    it "同じメールアドレスが登録されたとき無効な状態であること" do
      Company.create(
        name: "zzzz建設 株式会社",
        email: "zzzz@gmail.com",
        phone_number: "0312345678"
      )

      company = Company.create(
        name: "株式会社 xxxx建設",
        email: "zzzz@gmail.com",
        phone_number: "0356785678"
      )
      expect(company.errors[:email]).to include("has already been taken")
    end

    it "メールアドレスが無ければ無効な状態であること" do
      company = Company.create(
        name: "xxxx建設 株式会社",
        email: "zz--zz@gmail.com",
        phone_number: "0312345678"
      )
      expect(company.errors[:email]).to include("is invalid")
    end
  end

  describe '電話番号' do
    it "電話番号があれば有効な状態であること" do
      company = Company.create(
        name: "xxxx建設 株式会社",
        email: "xxxx@gmail.com",
        phone_number: "0312345678"
      )
      expect(company.errors[:phone_number]).to eq []
    end

    it "電話番号が無ければ無効な状態であること" do
      company = Company.create(
        name: "xxxx建設 株式会社",
        email: "xxxx@gmail.com",
        phone_number: ""
      )
      expect(company.errors[:phone_number]).to include("can't be blank")
    end

    it "同じ電話番号が登録されたとき無効な状態であること" do
      Company.create(
        name: "zzzz建設 株式会社",
        email: "zzzz@gmail.com",
        phone_number: "0312345678"
      )

      company = Company.create(
        name: "株式会社 xxxx建設",
        email: "xxxx@gmail.com",
        phone_number: "0312345678"
      )
      expect(company.errors[:phone_number]).to include("has already been taken")
    end

    it "電話番号が無ければ無効な状態であること" do
      company = Company.create(
        name: "xxxx建設 株式会社",
        email: "zzzz@gmail.com",
        phone_number: "03-1234-5678"
      )
      expect(company.errors[:phone_number]).to include("is invalid")
    end
  end
end

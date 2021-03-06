require 'rubygems'
require 'json'


# Clears the tables that will be seeded.
def clean_db
  BodyPart.delete_all
  Symptom.delete_all
  Disease.delete_all
  BodyPartSymptomDisease.delete_all
  Treatment.delete_all
  Plan.delete_all
  Copay.delete_all
  Log.delete_all
end


# Returns true if a record in a table exists.
def name_exists table, name
  return !table.where(name: name).empty?
end


# Builds a new symptom, disease, or body part.
def build_object table, name
  if name_exists(table, name)
    return
  end
  o = table.new(name: name)
  if !o.valid?
    return
  end
  o.save
end

# Builds a relationship tuple for a body part, symptom, and disease.
def build_relationship body_part_name, symptom_name, disease_name
  #puts "Calling build relationship for: #{body_part_name}, #{symptom_name}, #{disease_name}"
  body_part_set = BodyPart.where(name: body_part_name)
  symptom_set = Symptom.where(name: symptom_name)
  disease_set = Disease.where(name: disease_name)

  # If more than one object is found, or no objects found, then return, something went wrong.
  if body_part_set.size != 1
    #puts "Body part not found. #{body_part_set.inspect}"
    return
  elsif symptom_set.size != 1
    #puts "Symptom not found."
    return
  elsif disease_set.size != 1
    #puts "Disease not found."
    return
  end

  # Grab the first and only element in the sets.
  body_part = body_part_set.first
  symptom = symptom_set.first
  disease = disease_set.first

  tuple = BodyPartSymptom.new(body_part_id: body_part.id, symptom_id: symptom.id)
  if !tuple.valid?
    return
  end
  tuple.save

  tuple2 = BodyPartSymptomDisease.new(body_part_id: body_part.id, symptom_id: symptom.id, disease_id: disease.id)
  if !tuple2.valid?
    #puts "#{body_part_name}, #{symptom_name}, #{disease_name} - not a valid tuple."
    return
  end
  #puts "#{body_part_name}, #{symptom_name}, #{disease_name} - a valid tuple."
  tuple2.save
end

def setup_brandeis_plan
    brandeis=Plan.new(name:"Brandeis Insurance Plan", in_deductible:0.00, out_deductible:250.00)
    brandeis.save
    treatment=Treatment.new(resource_category:"coinsurance", name:"Co insurance-you pay this amount of a bill
after meeting your deductible and copay")
    treatment.save
    copay=Copay.new(plan_id:brandeis[:id], treatment_id:treatment[:id], in_network:0.0, out_network:0.2, copay_or_coinsurance_in:false, copay_or_coinsurance_out:false)
    copay.save
    brandeis.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"preventative", name:"Preventive services/immunization")
    treatment.save
    copay=Copay.new(plan_id:brandeis[:id],treatment_id:treatment[:id], in_network:0.0, out_network:0.2, copay_or_coinsurance_in:false, copay_or_coinsurance_out:false)
    copay.save
    brandeis.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"emergency", name:"Co-pay for emergency room visit")
    treatment.save
    copay=Copay.new(plan_id:brandeis[:id],treatment_id:treatment[:id], in_network:50.0, out_network:50.0, copay_or_coinsurance_in:true, copay_or_coinsurance_out:true)
    copay.save
    brandeis.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"office_visit", name:"Co-pay for office visit")
    treatment.save
    copay=Copay.new(plan_id:brandeis[:id],treatment_id:treatment[:id], in_network:20.0, out_network:0.2, copay_or_coinsurance_in:true, copay_or_coinsurance_out:false)
    copay.save
    brandeis.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"xray_labs_testing", name:"X-rays, labs, or testing")
    treatment.save
    copay=Copay.new(plan_id:brandeis[:id],treatment_id:treatment[:id], in_network:0.0, out_network:0.2, copay_or_coinsurance_in:false, copay_or_coinsurance_out:false)
    copay.save
    brandeis.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"mri_ct_pet", name:"MRI, CT scan, or PET")
    treatment.save
    copay=Copay.new(plan_id:brandeis[:id],treatment_id:treatment[:id], in_network:25.0, out_network:0.2, copay_or_coinsurance_in:true, copay_or_coinsurance_out:false)
    copay.save
    brandeis.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"mental_health", name:"Co-pay for Outpatient Mental Health")
    treatment.save
    copay=Copay.new(plan_id:brandeis[:id],treatment_id:treatment[:id], in_network:20.0, out_network:0.2, copay_or_coinsurance_in:true, copay_or_coinsurance_out:false)
    copay.save
    brandeis.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"inpatient", name:"Inpatient Care")
    treatment.save
    copay=Copay.new(plan_id:brandeis[:id],treatment_id:treatment[:id], in_network:0.0, out_network:0.2, copay_or_coinsurance_in:false, copay_or_coinsurance_out:false)
    copay.save
    brandeis.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"tier_1", name:"Generic Prescriptions")
    treatment.save
    copay=Copay.new(plan_id:brandeis[:id],treatment_id:treatment[:id], in_network:10.0, out_network:1.0, copay_or_coinsurance_in:true, copay_or_coinsurance_out:false, note:"Not covered out of network")
    copay.save
    brandeis.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"tier_2", name:"Brand Prescriptions")
    treatment.save
    copay=Copay.new(plan_id:brandeis[:id],treatment_id:treatment[:id], in_network:25.0, out_network:1.0, copay_or_coinsurance_in:true, copay_or_coinsurance_out:false, note:"Not covered out of network")
    copay.save
    brandeis.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"tier_3", name:"Specialty Brand Prescriptions")
    treatment.save
    copay=Copay.new(plan_id:brandeis[:id],treatment_id:treatment[:id], in_network:45.0, out_network:1.0, copay_or_coinsurance_in:true, copay_or_coinsurance_out:false, note:"Not covered out of network")
    copay.save
    brandeis.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"dental", name:"Dental Treatment for Injury to Natural Teeth")
    treatment.save
    copay=Copay.new(plan_id:brandeis[:id],treatment_id:treatment[:id], in_network:1.0, out_network:1.0, copay_or_coinsurance_in:false, copay_or_coinsurance_out:false, note:"Not covered")
    copay.save
    brandeis.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"eye", name:"Eye Examination")
    treatment.save
    copay=Copay.new(plan_id:brandeis[:id],treatment_id:treatment[:id], in_network:0.0, out_network:0.2, copay_or_coinsurance_in:false, copay_or_coinsurance_out:false, note:"One covered every two years")
    copay.save
    brandeis.copays << copay
    treatment.copays << copay
end

def setup_generic_plan
    generic=Plan.new(name:"Bently University Plan", in_deductible:100.00, out_deductible:350.00)
    generic.save
    treatment=Treatment.new(resource_category:"coinsurance", name:"Co insurance-you pay this amount of a bill
after meeting your deductible and copay")
    treatment.save
    copay=Copay.new(plan_id:generic[:id], treatment_id:treatment[:id], in_network:0.05, out_network:0.3, copay_or_coinsurance_in:false, copay_or_coinsurance_out:false)
    copay.save
    generic.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"office_visit", name:"Co-pay for office visit")
    treatment.save
    copay=Copay.new(plan_id:generic[:id],treatment_id:treatment[:id], in_network:30.0, out_network:0.3, copay_or_coinsurance_in:true, copay_or_coinsurance_out:false)
    copay.save
    generic.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"emergency", name:"Co-pay for emergency room visit")
    treatment.save
    copay=Copay.new(plan_id:generic[:id],treatment_id:treatment[:id], in_network:75.0, out_network:100.0, copay_or_coinsurance_in:true, copay_or_coinsurance_out:true)
    copay.save
    generic.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"prescriptions", name:"All Prescriptions")
    treatment.save
    copay=Copay.new(plan_id:generic[:id],treatment_id:treatment[:id], in_network:0.3, out_network:1.0, copay_or_coinsurance_in:false, copay_or_coinsurance_out:false, note:"Not covered out of network")
    copay.save
    generic.copays << copay
    treatment.copays << copay
end

def setup_fake_plan
    fake=Plan.new(name:"Boston University Plan", in_deductible:50.00, out_deductible:500.00)
    fake.save
    treatment=Treatment.new(resource_category:"coinsurance", name:"Co insurance-you pay this amount of a bill
after meeting your deductible and copay")
    treatment.save
    copay=Copay.new(plan_id:fake[:id], treatment_id:treatment[:id], in_network:0.05, out_network:0.3, copay_or_coinsurance_in:false, copay_or_coinsurance_out:false)
    copay.save
    fake.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"office_visit", name:"Co-pay for office visit")
    treatment.save
    copay=Copay.new(plan_id:fake[:id],treatment_id:treatment[:id], in_network:40.0, out_network:0.4, copay_or_coinsurance_in:true, copay_or_coinsurance_out:false)
    copay.save
    fake.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"emergency", name:"Co-pay for emergency room visit")
    treatment.save
    copay=Copay.new(plan_id:fake[:id],treatment_id:treatment[:id], in_network:75.0, out_network:100.0, copay_or_coinsurance_in:true, copay_or_coinsurance_out:true)
    copay.save
    fake.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"prescriptions", name:"All Prescriptions")
    treatment.save
    copay=Copay.new(plan_id:fake[:id],treatment_id:treatment[:id], in_network:0.2, out_network:1.0, copay_or_coinsurance_in:false, copay_or_coinsurance_out:false, note:"Not covered out of network")
    copay.save
    fake.copays << copay
    treatment.copays << copay
    treatment=Treatment.new(resource_category:"labs", name:"Lab Work")
    treatment.save
    copay=Copay.new(plan_id:fake[:id],treatment_id:treatment[:id], in_network:50.0, out_network:75.0, copay_or_coinsurance_in:true, copay_or_coinsurance_out:true)
    copay.save
    fake.copays << copay
    treatment.copays << copay
end

def setup_demo_user
    unless User.find_by(name:"Jane Doe").nil?
        User.delete(User.find_by(name:"Jane Doe"))
    end
    user1=User.new(name:"Jane Doe", email:"jane.doe@gmail.com")
    user1.password_digest=User.digest("password")
    user1.save
    id=user1[:id]
    # now = DateTime.now
    # log=Log.new(symptom_id:Symptom.find_by(name:"cough")[:id], severity:6, visit_id: -1, created_at:DateTime.new(now.year, now.month, now.day, now.hour, now.minute, now.second, now.zone), user_id:id)
    # log.save
    # user1.logs << log
    # log=Log.new(symptom_id:Symptom.find_by(name:"cough")[:id], severity:4, visit_id: -1, created_at:DateTime.new(now.year, now.month, now.day-1, now.hour, now.minute, now.second, now.zone), user_id:id)
    # log.save
    # user1.logs << log
    # log=Log.new(symptom_id:Symptom.find_by(name:"cough")[:id], severity:5, visit_id: -1, created_at:DateTime.new(now.year, now.month, now.day-1, now.hour, now.minute, now.second, now.zone), user_id:id)
    # log.save
    # user1.logs << log
    # log=Log.new(symptom_id:Symptom.find_by(name:"fever")[:id], severity:6, visit_id: -1, created_at:DateTime.new(now.year, now.month, now.day-1, now.hour, now.minute, now.second, now.zone), user_id:id)
    # log.save
    # user1.logs << log
    # log=Log.new(symptom_id:Symptom.find_by(name:"fever")[:id], severity:7, visit_id: -1, created_at:DateTime.new(now.year, now.month, now.day-1, now.hour, now.minute, now.second, now.zone), user_id:id)
    # log.save
    # user1.logs << log
    # log=Log.new(symptom_id:Symptom.find_by(name:"runny")[:id], severity:5, visit_id: -1, created_at:DateTime.new(now.year, now.month, now.day-5, now.hour, now.minute, now.second, now.zone), user_id:id)
    # log.save
    # user1.logs << log
    # log=Log.new(symptom_id:Symptom.find_by(name:"runny")[:id], severity:6, visit_id: -1, created_at:DateTime.new(now.year, now.month, now.day-3, now.hour, now.minute, now.second, now.zone), user_id:id)
    # log.save
    # user1.logs << log
    # log=Log.new(symptom_id:Symptom.find_by(name:"chills")[:id], severity:4, visit_id: -1, created_at:DateTime.new(now.year, now.month, now.day-3, now.hour, now.minute, now.second, now.zone), user_id:id)
    # log.save
    # user1.logs << log
    # log=Log.new(symptom_id:Symptom.find_by(name:"chills")[:id], severity:6, visit_id: -1, created_at:DateTime.new(now.year, now.month, now.day-2, now.hour, now.minute, now.second, now.zone), user_id:id)
    # log.save
    # user1.logs << log
    # log=Log.new(symptom_id:Symptom.find_by(name:"chills")[:id], severity:6, visit_id: -1, created_at:DateTime.new(now.year, now.month, now.day-1, now.hour, now.minute, now.second, now.zone), user_id:id)
    # log.save
    # user1.logs << log
end
# BEGIN SEEDING

clean_db
setup_brandeis_plan
setup_generic_plan
setup_fake_plan
elms = JSON.parse(open("./json/body_part_symptom_disease.json", 'r').read.to_s)
elms.each do |elm|
  bp_name = elm["Body Part"].strip
  s_name = elm["Symptom"].strip
  d_name = elm["Disease"].strip

  build_object(BodyPart, bp_name)
  build_object(Symptom, s_name)
  build_object(Disease, d_name)

  build_relationship(bp_name.downcase, s_name.downcase, d_name.downcase)
end
setup_demo_user

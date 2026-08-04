require "csv"

namespace :import_data do
  desc "Import data from CSV file"
  task import_katja: :environment do
    file_path = Rails.root.join("lib", "tasks", "import", "reads_katja.csv")
    stats = {
      created: 0, skipped: 0
    }
    CSV.foreach(file_path, headers: true) do |row|
      if row["reading_status"] == "on list"
        stats[:skipped] += 1
        Log.warning("Skipping on list read: #{row["title"]}")
        next
      end
      read = Read.find_or_create_by(title: row["title"], user: User.find_by(username: "Katja"))
      read.update(reading_status: row["reading_status"] == "currently reading" ? :currently_reading : :have_read)
      read.update(author: row["author"])
      read.update(platform: row["platform"])
      read.update(pairing: row["pairing"])
      read.update(words: row["words"])
      read.update(chapters: row["chapters"])
      read.update(recommended: row["recommended"] == "ja" ? true : false)
      read.update(link: row["link"])
      read.save!
      stats[:created] += 1
      Log.success("Imported read: #{read.title}")
    end
    puts "---"
    Log.success("Created: #{stats[:created]}")
    Log.error("Skipped: #{stats[:skipped]}")
  end

  task import_isi: :environment do
    file_path = Rails.root.join("lib", "tasks", "import", "reads_isi.csv")
    stats = {
      created: 0, skipped: 0
    }

    READING_STATUSES = {
      "Am Lesen" => :currently_reading,
      "Gelesen" => :have_read,
      "Nicht gelesen" => :want_to_read
    }

    Log.warning("Importing with username Isabella")
    CSV.foreach(file_path, headers: true) do |row|
      read = Read.find_or_create_by(title: row["title"], user: User.find_by(username: "Isabella"))

      unless READING_STATUSES.key?(row["reading_status"].strip)
        Log.error("Unknown reading status: #{row["reading_status"]}")
        exit
      end

      read.update(reading_status: READING_STATUSES[row["reading_status"]])
      read.update(author: row["author"])
      read.update(platform: row["platform"])
      read.update(pairing: row["pairing"])
      read.update(words: row["words"])
      read.update(chapters: row["chapters"])
      read.update(rating: row["rating"].to_i / 2)
      read.update(link: row["link"])
      read.save!
      stats[:created] += 1
      Log.success("Imported read: #{read.title}")
    end
    puts "---"
    Log.success("Created or Updated: #{stats[:created]}")
    Log.error("Skipped: #{stats[:skipped]}")
  end

  task import_lena: :environment do
    file_path = Rails.root.join("lib", "tasks", "import", "reads_lena.csv")
    stats = {
      created: 0, skipped: 0
    }

    READING_STATUSES = {
      "done" => :have_read,
      "auf der Leseliste" => :want_to_read,
      "currently reading" => :currently_reading
    }

    CSV.foreach(file_path, headers: true) do |row|
      read = Read.find_or_create_by(title: row["title"], user: User.find_by(username: "Lena"))

      unless READING_STATUSES.key?(row["reading_status"].strip)
        Log.error("Unknown reading status: #{row["reading_status"]}")
        exit
      end

      read.update(reading_status: READING_STATUSES[row["reading_status"].strip])
      read.update(author: row["author"])
      read.update(platform: row["platform"])
      read.update(pairing: row["pairing"])
      read.update(words: row["words"])
      read.update(chapters: row["chapters"])

      if row["rating_note"]
        read.update(rating: row["rating_note"].scan(/\d+\/10/).first.to_i / 2)
      end

      read.save!
      stats[:created] += 1
      Log.success("Imported read: #{read.title}")
    end
    puts "---"
    Log.success("Created or Updated: #{stats[:created]}")
    Log.error("Skipped: #{stats[:skipped]}")
  end
end

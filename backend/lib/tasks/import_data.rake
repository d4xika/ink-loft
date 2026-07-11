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
        Log.warning("Skipping on list book: #{row["title"]}")
        next
      end
      book = Book.find_or_create_by(title: row["title"], user: User.find_by(username: "Katja"))
      book.update(reading_status: row["reading_status"] == "currently reading" ? :currently_reading : :have_read)
      book.update(author: row["author"])
      book.update(platform: row["platform"])
      book.update(pairing: row["pairing"])
      book.update(words: row["words"])
      book.update(chapters: row["chapters"])
      book.update(recommended: row["recommended"] == "ja" ? true : false)
      book.update(link: row["link"])
      book.save!
      stats[:created] += 1
      Log.success("Imported book: #{book.title}")
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

    CSV.foreach(file_path, headers: true) do |row|
      book = Book.find_or_create_by(title: row["title"], user: User.find_by(username: "Isabella"))

      unless READING_STATUSES.key?(row["reading_status"].strip)
        Log.error("Unknown reading status: #{row["reading_status"]}")
        exit
      end

      book.update(reading_status: READING_STATUSES[row["reading_status"]])
      book.update(author: row["author"])
      book.update(platform: row["platform"])
      book.update(pairing: row["pairing"])
      book.update(words: row["words"])
      book.update(chapters: row["chapters"])
      book.update(rating: row["rating"].to_i / 2)
      book.update(link: row["link"])
      book.save!
      stats[:created] += 1
      Log.success("Imported book: #{book.title}")
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
      book = Book.find_or_create_by(title: row["title"], user: User.find_by(username: "Lena"))

      unless READING_STATUSES.key?(row["reading_status"].strip)
        Log.error("Unknown reading status: #{row["reading_status"]}")
        exit
      end

      book.update(reading_status: READING_STATUSES[row["reading_status"].strip])
      book.update(author: row["author"])
      book.update(platform: row["platform"])
      book.update(pairing: row["pairing"])
      book.update(words: row["words"])
      book.update(chapters: row["chapters"])

      if row["rating_note"]
        book.update(rating: row["rating_note"].scan(/\d+\/10/).first.to_i / 2)
      end

      book.save!
      stats[:created] += 1
      Log.success("Imported book: #{book.title}")
    end
    puts "---"
    Log.success("Created or Updated: #{stats[:created]}")
    Log.error("Skipped: #{stats[:skipped]}")
  end
end

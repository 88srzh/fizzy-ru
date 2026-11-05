class Account::Seeder
  attr_reader :account, :creator

  def initialize(account, creator)
    @account = account
    @creator = creator
  end

  def seed
    Current.set(user: creator, account: account) do
      populate
    end
  end

  def seed!
    raise "Нельзя запускать в production-окружении" unless Rails.env.local?

    delete_everything
    seed
  end

  private
    def populate
      # ---------------
      # Playground Board
      # ---------------
      playground = account.boards.create! name: "Playground", creator: creator, all_access: true
      playground.update! auto_postpone_period: 365.days

      # Cards
      playground.cards.create! creator: creator, title: "Наконец, посмотрите ознакомительное видео Fizzy", status: "published", description: <<~HTML
        <p>В Fizzy можно сделать гораздо больше. В видео ниже основатель и CEO 37signals Джейсон Фрид расскажет вам об основах всего за 17 минут.</p>
        <action-text-attachment url="https://videos.37signals.com/fizzy/assets/videos/fizzyorientation-4k.mp4" caption="Ознакомление с Fizzy" content-type="video/mp4" filename="fizzyorientation-4k.mp4"></action-text-attachment>
      HTML

      # TODO: Replace the video here with a screencap of creating a passkey
      playground.cards.create! creator: creator, title: "Затем настройте ключ доступа (Passkey)", status: "published", description: <<~HTML
        <p>Ключи доступа (Passkeys) позволяют безопасно входить без паролей и кодов из писем. Чтобы настроить ключ, откройте меню Fizzy и перейдите в «<b><strong>Мой профиль > Управление ключами доступа</b></strong>». Использование ключа доступа необязательно, но рекомендуется.</p>
        <action-text-attachment url="https://videos.37signals.com/fizzy/assets/videos/creating_a_passkey.mp4" alt="Демонстрация добавления ключа доступа" caption="Создайте ключ доступа для входа без паролей и кодов из писем" content-type="video/mp4" filename="creating_a_passkey.mp4"></action-text-attachment>
      HTML

      playground.cards.create! creator: creator, title: "Теперь скопируйте ссылку-приглашение, чтобы пригласить кого-то ещё", status: "published", description: <<~HTML
        <p>Откройте меню Fizzy, выберите «<b><strong>+ Добавить людей</b></strong>», затем скопируйте ссылку-приглашение. Вы можете передать эту ссылку кому-то ещё, чтобы они создали себе вход в ваш аккаунт.</p>
        <action-text-attachment url="https://videos.37signals.com/fizzy/assets/images/invite-link.gif" alt="Демонстрация копирования ссылки-приглашения" caption="Получите ссылку для приглашения коллег" content-type="image/*" filename="invite-link.gif" presentation="gallery"></action-text-attachment>
      HTML

      playground.cards.create! creator: creator, title: "Затем вернитесь на главную, чтобы посмотреть активность", status: "published", description: <<~HTML
        <p>Нажмите «1» или откройте меню Fizzy и выберите «Главная».</p>
        <action-text-attachment url="https://videos.37signals.com/fizzy/assets/images/back-to-home.gif" alt="Демонстрация перехода на главную" caption="Вернитесь на главную, чтобы увидеть последнюю активность" content-type="image/*" filename="back-to-home.gif" presentation="gallery"></action-text-attachment>
      HTML

      playground.cards.create! creator: creator, title: "Теперь посмотрите все карточки, назначенные вам", status: "published", description: <<~HTML
        <p>Откройте меню Fizzy в верхней части экрана и выберите «<b><strong>Назначенные мне</b></strong>» или просто нажмите «2» на клавиатуре в любой момент.</p>
        <action-text-attachment url="https://videos.37signals.com/fizzy/assets/images/all-assigned.gif" alt="Демонстрация перехода к «Назначенным мне»" caption="Посмотрите все карточки, назначенные вам" content-type="image/*" filename="all-assigned.gif" presentation="gallery"></action-text-attachment>
      HTML

      playground.cards.create! creator: creator, title: "Затем откройте меню Fizzy", status: "published", description: <<~HTML
        <p>Меню Fizzy — это способ навигации по приложению. Нажмите «<b><strong>Fizzy</b></strong>» в верхней части экрана или клавишу «J» на клавиатуре, чтобы открыть его.</p>
        <action-text-attachment url="https://videos.37signals.com/fizzy/assets/images/open-menu.gif" alt="Демонстрация открытия главного меню" caption="Откройте меню Fizzy" content-type="image/*" filename="open-menu.gif" presentation="gallery"></action-text-attachment>
      HTML

      playground.cards.create! creator: creator, title: "Далее назначьте эту карточку на себя", status: "published", description: <<~HTML
        <p>Нажмите на маленькую голову со знаком + рядом с ней, затем выберите себя.</p>
        <action-text-attachment url="https://videos.37signals.com/fizzy/assets/images/assign-to-self.gif" alt="Демонстрация назначения карточки" caption="Назначьте это на себя" content-type="image/*" filename="assign-to-self.gif" presentation="gallery"></action-text-attachment>
      HTML

      playground.cards.create! creator: creator, title: "Теперь отметьте эту карточку тегом «Design», затем переместите её в YES", status: "published", description: <<~HTML
        <p>Нажмите на маленькую иконку тега, введите «design», затем «<b><strong>Создать тег</b></strong>». Затем переместите карточку в новую колонку «YES», созданную на предыдущем шаге.</p>
        <action-text-attachment url="https://videos.37signals.com/fizzy/assets/images/tag-design.gif" alt="Демонстрация добавления тега к карточке" caption="Отметьте это тегом #design" content-type="image/*" filename="tag-design.gif" presentation="gallery"></action-text-attachment>
      HTML

      playground.cards.create! creator: creator, title: "Далее создайте ещё две колонки", status: "published", description: <<~HTML
        <ol>
          <li>Создайте одну под названием "Yes"</li>
          <li>Создайте ещё одну под названием "Working on"</li>
        </ol>
        <p>Вернитесь к виду доски, нажмите маленький «+» справа от колонки DONE, назовите колонку, выберите цвет и повторите снова.</p>
        <p><br></p>
        <p>После этого перетащите эту карточку в «DONE» или выберите «DONE» на боковой панели.</p>
        <action-text-attachment url="https://videos.37signals.com/fizzy/assets/images/make-columns.gif" alt="Демонстрация добавления колонок" caption="Создайте ещё две колонки" content-type="image/*" filename="make-columns.gif" presentation="gallery"></action-text-attachment>
      HTML

      playground.cards.create! creator: creator, title: "Во-вторых, переместите эту карточку в NOT NOW", status: "published", description: <<~HTML
        <p>Вы можете либо выбрать «NOT NOW» на боковой панели, либо вернуться к виду доски и перетащить эту карточку в колонку «NOT NOW» слева.</p>
        <p><br></p>
        <action-text-attachment url="https://videos.37signals.com/fizzy/assets/images/not-now.gif" alt="Демонстрация перемещения карточки в Not Now" caption="Переместить в Not Now" content-type="image/*" filename="not-now.gif" presentation="gallery"></action-text-attachment>
      HTML

      playground.cards.create! creator: creator, title: "Сначала переименуйте эту карточку", status: "published", description: <<~HTML
        <ol>
          <li>Нажмите на заголовок, и вы сможете переименовать карточку, изменить описание или добавить больше информации.</li>
          <li>Затем нажмите "Отметить как готовую" внизу карточки.</li>
          <li>Наконец, нажмите “<b><strong>Назад в Playground</strong></b>” в верхнем левом углу экрана, чтобы вернуться на доску.</li>
        </ol>
        <action-text-attachment url="https://videos.37signals.com/fizzy/assets/images/rename.gif" alt="Демонстрация переименования карточки" caption="Переименуйте эту карточку" content-type="image/*" filename="rename.gif" presentation="gallery"></action-text-attachment>
      HTML
    end

    def delete_everything
      Current.set(user: creator, account: account) do
        account.boards.destroy_all
      end
    end
end

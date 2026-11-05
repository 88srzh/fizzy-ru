module CommentsHelper
  def new_comment_placeholder(card)
    if card.creator == Current.user && card.comments.empty?
      "Далее добавьте заметки, контекст, изображения или видео об этом…"
    else
      "Введите комментарий…"
    end
  end
end

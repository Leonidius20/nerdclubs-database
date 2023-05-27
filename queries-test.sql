

SELECT c.*,
       users.username,
       COALESCE(upvotes.upvote_count, 0) - COALESCE(downvotes.downvote_count, 0) AS rating,
    CASE
    WHEN cv.is_positive IS NOT NULL THEN TRUE
    ELSE FALSE
  END AS user_voted,
  cv.is_positive AS user_vote_positive
FROM comments c
    left join users on c.author_user_id = users.user_id
LEFT JOIN (
  SELECT comment_id, COUNT(*) AS upvote_count
  FROM comment_votes
  WHERE is_positive = true
  GROUP BY comment_id
) upvotes ON c.comment_id = upvotes.comment_id
LEFT JOIN (
  SELECT comment_id, COUNT(*) AS downvote_count
  FROM comment_votes
  WHERE is_positive = false
  GROUP BY comment_id
) downvotes ON c.comment_id = downvotes.comment_id
LEFT JOIN (
  SELECT
    comment_id,
    is_positive
  FROM
    comment_votes
  WHERE
    user_id = 10
) cv ON c.comment_id = cv.comment_id
 WHERE post_id = 1 ORDER BY created_at ASC;
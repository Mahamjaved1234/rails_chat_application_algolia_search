FROM ruby:3.1.2
ADD . /eshop
WORKDIR /eshop
RUN bundle install

ENV RAILS_ENV development
ENV RAILS_SERVE_STATIC_FILES true

EXPOSE 3000
CMD ["bash"]


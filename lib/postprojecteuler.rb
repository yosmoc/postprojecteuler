#!/usr/bin/env ruby

require 'rubygems'
require 'uri'
require 'mechanize'
require 'logger'
require 'pp'
require 'pit'
require 'ostruct'

class PostProjectEulerError < Exception; end
class NotLoggedinError < PostProjectEulerError; end

class PostProjectEuler
  VERSION = '0.0.1'

  BASE = URI("http://projecteuler.net/")

  def initialize(config)
    @config = OpenStruct.new(config)
    @agent = WWW::Mechanize.new
    @logged = false
  end

  def login
    unless logined?
      login_page = @agent.get(BASE + '/index.php?section=login')
      login_form = login_page.forms.first
      login_form.username = @config.username
      login_form.password = @config.password
      @agent.submit(login_form, login_form.buttons.name('login'))
      @logged = true
    end
    @logged
  end

  def logout
    logined_check

    logout_page = @agent.get(BASE + './index.php?section=logout')
    @logged = false
  end

  def post(question, answer)
    logined_check

    problem_page = @agent.get(BASE + "/index.php?section=problems&id=#{question}")
    answer_form = problem_page.forms.first
    if !!answer_form['guess']
      answer_form['guess'] = answer
      result = @agent.submit(answer_form, answer_form.buttons.name(''))
      answer_check(result)
      return result
    else
      raise PostProjectEulerError, "problem #{question} is already solved, please check problem number."
    end
  end

  private
  def logined?
    @logged
  end

  def answer_check(result)
    if result.body =~ /(Sorry, but the answer you gave appears to be incorrect)/ then
      puts $1
    elsif
      puts 'correct'
    end
  end

  def logined_check
    unless logined?
      raise NotLoggedinError, 'Not Logged in. Please call login method and check username and password'
    end
  end
end

if __FILE__ == $0
  log = Logger.new(STDOUT)
  log.level = Logger::ERROR

  if ARGV.size == 1 then
    post_ppe = PostProjectEuler.new(Pit.get("projecteuler.net", :require => {
               'username' => 'username',
               'password' => 'password'
               }))
    post_ppe.login
    post_ppe.post(ARGV[0], $stdin.gets.chomp)
  else
    log.error('please input');
  end
end

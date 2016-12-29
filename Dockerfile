FROM centos:centos6
MAINTAINER naokomada@gmail.com

RUN mkdir -m 755 /var/qmail

RUN groupadd nofiles && \
 useradd -M -g nofiles -d /var/qmail/alias -s /bin/false alias && \
 useradd -M -g nofiles -d /var/qmail -s /bin/false qmaild && \
 useradd -M -g nofiles -d /var/qmail -s /bin/false qmaill && \
 useradd -M -g nofiles -d /var/qmail -s /bin/false qmailp

RUN groupadd qmail && \
 useradd -M -g qmail -d /var/qmail -s /bin/false qmailq && \
 useradd -M -g qmail -d /var/qmail -s /bin/false qmailr && \
 useradd -M -g qmail -d /var/qmail -s /bin/false qmails

RUN useradd -g users -d /home/mailuser1 mailuser1

RUN cd ~/

RUN yum -y update
RUN yum -y install wget
RUN yum -y install patch
RUN yum -y install gcc
RUN yum -y install xinetd

RUN wget http://qmail.teraren.com/qmail-1.03.tar.gz && \
    wget http://www.itheart.com/phpgw/qmail-date-localtime.patch

RUN tar zxvf qmail-1.03.tar.gz
RUN mv qmail-date-localtime.patch qmail-1.03
RUN cd qmail-1.03
RUN patch < qmail-date-localtime.patch

ADD ./files/error.h ~/qmail-1.03/error.h
RUN make setup check
RUN ./config-fast qmail3

ADD ./files/rc /var/qmail/rc

ADD ./files/smtp /etc/xinetd.d/smtp
CMD /usr/sbin/xinetd -dontfork